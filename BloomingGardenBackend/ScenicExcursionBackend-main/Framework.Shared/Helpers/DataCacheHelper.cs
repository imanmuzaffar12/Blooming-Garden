using Newtonsoft.Json;
using ServiceStack.CacheAccess;
using ServiceStack.CacheAccess.Providers;
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Caching;
using System.Text;
using System.Threading;

namespace Framework.Shared.Helpers
{
    interface IDataCache
    {
        void SetData<T>(string cacheKey, T objectToCache, int expireCacheInSecs);
        T GetData<T>(string cacheKey);
        void RemoveEntry(string cacheKey);
        bool ContainsKey(string cacheKey);
    }

    public abstract class DataCache
    {
        protected TimeSpan GetCacheExpirationTimeSpan(int seconds)
        {
            int h, m, s;
            h = m = s = 0;

            if (seconds >= 60)
            {
                m = seconds / 60;

                if (m >= 60)
                {
                    h = m / 60;
                    m = (m % 60);
                }

                s = (seconds % 60);
            }
            else
            {
                s = seconds;
            }

            return (new TimeSpan(h, m, s));
        }
    }

    public class InMemoryDataCache : DataCache, IDataCache
    {
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        private static readonly InMemoryDataCache _singleton = new InMemoryDataCache();
        public static InMemoryDataCache Instance
        {
            get { return (_singleton); }
        }
        protected InMemoryDataCache()
        {
        }

        public void SetData<T>(string cacheKey, T objectToCache, int expireCacheInSecs)
        {
            // MSDN: Entry is updated if it exists
            MemoryCache.Default.Set(new CacheItem(cacheKey,
                                                  objectToCache),
                                    GetDataCacheItemPolicy(expireCacheInSecs));
        }
        public T GetData<T>(string cacheKey)
        {
            T result = default(T);

            result = (T)MemoryCache.Default[cacheKey];

            return result;
        }
        public void RemoveEntry(string cacheKey)
        {
            if (ContainsKey(cacheKey))
            {
                MemoryCache.Default.Remove(cacheKey);
            }
        }
        public bool ContainsKey(string cacheKey)
        {
            bool result = false;

            if (MemoryCache.Default.Contains(cacheKey))
            {
                result = true;
            }

            return (result);
        }

        private static CacheItemPolicy GetDataCacheItemPolicy(int absoluteExpirationInSeconds)
        {
            CacheItemPolicy cip = new CacheItemPolicy();
            try
            {
                cip.AbsoluteExpiration = new DateTimeOffset(DateTime.Now.AddSeconds(absoluteExpirationInSeconds));
            }
            catch (Exception ex)
            {
                logger.ErrorException(string.Empty, ex);
                throw;
            }
            return (cip);
        }

        public List<string> GetAllCacheKeys()
        {
            List<string> CacheKeys = new List<string>();
            foreach (var item in MemoryCache.Default)
            {
                CacheKeys.Add(item.Key.ToString());
            }
            return CacheKeys;
        }
    }

    public class ServiceExecutionHelper
    {
        static NLog.Logger _logger = NLog.LogManager.GetCurrentClassLogger();

        private static ServiceExecutionHelper _singleton = new ServiceExecutionHelper();
        public static ServiceExecutionHelper Instance
        {
            get { return (_singleton); }
        }
        protected ServiceExecutionHelper()
        {
        }

        private IDataCache DataCacheInstance
        {
            get { return InMemoryDataCache.Instance; }
        }

        #region Delegates & DataStructures
        //public delegate void AsyncCallDelegateWithoutParameters();
        //private delegate void CacheUpdateDelegateWithoutParameters();
        private ConcurrentDictionary<string, object> asyncCacheRefillMutexes = new ConcurrentDictionary<string, object>();
        private ConcurrentDictionary<string, int> asyncCallStatusMutexes = new ConcurrentDictionary<string, int>();
        #endregion

        // TODO: Cache only certain number of pages
        public T GetDataAsync<T>(Func<T> codeBlock, string cacheKey = null, int cacheExpirationTimeInSecs = 0, int asyncAfterSecs = 0, string apiURL = "", object postedData = null, bool IsManualKey = false, string apiName = "", bool isCacheAllowed = false)
        {
            int redisAsyncUpdateSeconds = 0;

            #region Extract Caching Info and Set Default or Custom Cache Timeouts
            Delegate[] list = ((System.Delegate)(codeBlock)).GetInvocationList();
            StackFrame frame = new StackFrame(1);

            //GenerateCacheKey function generates cach key by using codeblock's class name, function name , parameters name and parameters value.
            //Example: CodeBlock's class name is "ArticleServices", function is "GetArticleByID" : Parameter is "ID" : Parameter Value is "35678"
            //With above scenario Key generated will be CK_ArticleServices_GetArticleByID_ID_35678
            var cacheMetaInfo = GenerateCacheKey(list, frame, IsManualKey, apiName);
            apiName = !string.IsNullOrEmpty(apiName) ? apiName : "_";
            cacheKey = string.IsNullOrEmpty(cacheKey) ? cacheMetaInfo.CacheKey : string.Format("CK_{0}_{1}_{2}", cacheMetaInfo.ClassName, cacheMetaInfo.MethodName, cacheKey);

            cacheKey = cacheKey.ToUpper();

            cacheExpirationTimeInSecs = cacheExpirationTimeInSecs == 0 ? 900 : cacheExpirationTimeInSecs;

            asyncAfterSecs = asyncAfterSecs == 0 ? 3600 : asyncAfterSecs;
            asyncAfterSecs = 120;

            #endregion

            T result = default(T);
            bool isPrimaryCacheFiller = false;

#if DEBUG_SEH
            Stopwatch sw = new Stopwatch();
            sw.Start();
            int cacheFillerStatus = 0; // 1 = PrimaryCacheFiller, 2 = PrimaryCacheFillerCandidate, 3 = CacheAsyncFillerCandidate, 4 = CacheAsyncFiller
#endif

            try
            {

                if (!GlobalAppConfigs.UseCachedData)
                {
                    result = GetData<T>(codeBlock, apiURL, postedData);
                }
                else if (!isCacheAllowed)
                {
                    result = GetData<T>(codeBlock, apiURL, postedData);
                }
                else
                {
                    // create mutex objects as required

                    if (!asyncCacheRefillMutexes.ContainsKey(cacheKey))
                    {
                        asyncCacheRefillMutexes.TryAdd(cacheKey, new object());
                        asyncCallStatusMutexes.TryAdd(cacheKey, 0);
                    }

                    // If cache does not have data
                    if (!DataCacheInstance.ContainsKey(cacheKey))
                    {
#if DEBUG_SEH
                        //_logger.Debug("Thread {0} About to lock on {1}", System.Threading.Thread.CurrentThread.ManagedThreadId, cacheKey);
#endif
                        #region
                        // acquire a lock and block all other threads trying to fill this cache
                        lock (asyncCacheRefillMutexes[cacheKey])
                        {
#if DEBUG_SEH
                            //_logger.Debug("Thread {0} inside the Lock for {1}", System.Threading.Thread.CurrentThread.ManagedThreadId, cacheKey);
                            cacheFillerStatus = 2;
#endif
                            // Set this true here so that this same thread does not try to refill the cache again below
                            // And so that the waiting threads don't either as (technically) the cache just got filled by the previous thread
                            isPrimaryCacheFiller = true;

                            // This is here so that if the previous thread successfully filled the cache while
                            // the current one was waiting it won't try to refill it
                            if (!DataCacheInstance.ContainsKey(cacheKey))
                            {
#if DEBUG_SEH
                                cacheFillerStatus = 1;
#endif
                                // Get the data locally or from the REST API
                                result = GetData<T>(codeBlock, apiURL, postedData);

                                if (result != null)
                                {
                                    // Cache the result
                                    DataCacheInstance.SetData<T>(cacheKey, result, cacheExpirationTimeInSecs);
                                    ResetAsyncPeriod(cacheKey, asyncAfterSecs);
                                }
                                else
                                {
                                    _logger.Warn("ResultSet is empty, Not caching anything for CacheKey {0}",
                                        cacheMetaInfo.CacheKey);
                                }
                            }
                            else
                            {
                                // This case happens for all such threads that were blocked trying to be the primaryFiller :)
                                result = DataCacheInstance.GetData<T>(cacheKey);
                            }
                        }
                        #endregion
#if DEBUG_SEH
                        //_logger.Debug("Thread {0} exited the Lock for {1}", System.Threading.Thread.CurrentThread.ManagedThreadId, cacheKey);
#endif
                    }

                    if (!isPrimaryCacheFiller)
                    {
#if DEBUG_SEH
                        cacheFillerStatus = 3;
#endif
                        // NOTE: Any thread that was not the primary cache filler AND was not waiting to be the primaryFiller, can enter this code block

                        // Get data from cache
                        result = DataCacheInstance.GetData<T>(cacheKey);

                        if (IsReadyForAsyncCall(cacheKey, asyncAfterSecs))
                        {
                            bool gotLock = false;
                            Monitor.TryEnter(asyncCacheRefillMutexes[cacheKey], ref gotLock);

                            // Lock will be acquired by only 1 thread the who will initiate the async call, rest of em will just take the data from the cache and leave
                            // This way we won't be sending many Async calls unnecessarily
                            if (gotLock)
                            {
#if DEBUG_SEH
                                cacheFillerStatus = 4;
#endif
                                #region Defining the Anonymous Method that performs the ASync Cache Update
                                Action c = () =>
                                {
                                    try
                                    {
                                        T item = GetData<T>(codeBlock, apiURL, postedData);

                                        if (item != null)
                                        {
                                            DataCacheInstance.SetData(cacheKey, item, cacheExpirationTimeInSecs);
                                            ResetAsyncPeriod(cacheKey, asyncAfterSecs);
                                        }
                                        else
                                        {
                                            _logger.Warn("ResultSet is empty, Not reCaching anything for CacheKey {0}",
                                                cacheMetaInfo.CacheKey);
                                        }
                                    }
                                    catch (Exception ex)
                                    {

                                    }

                                    asyncCallStatusMutexes[cacheKey] = 0;
                                };
                                #endregion

                                #region Invoke the Async Method
                                try
                                {
                                    if (asyncCallStatusMutexes[cacheKey] == 0)
                                    {
                                        asyncCallStatusMutexes[cacheKey] = 1;

                                        c.BeginInvoke(new AsyncCallback((ar) => { }), cacheKey);
                                    }
                                }
                                catch (Exception ex)
                                {

                                }
                                finally
                                {
                                    Monitor.Exit(asyncCacheRefillMutexes[cacheKey]);
                                }
                                #endregion
                            }
                        }
                    }
                }
            } // End Try
            catch (Exception ex)
            {

                throw;
            }

#if DEBUG_SEH
            sw.Stop();
            if (sw.ElapsedMilliseconds > AppConfigHelper.GetConfigValue<int>("TrackGetDataAsyncMethodsForMilliSecs")
                || result == null /* This helps us find out the Kinda problem we were facing in GetAllLanguages() where the source of the LINQ query was null*/)
            {
                string cacheFillerStatusText = string.Empty;
                switch (cacheFillerStatus)
                {
                    case 1:
                        cacheFillerStatusText = "PrimaryCacheFiller";
                        break;
                    case 2:
                        cacheFillerStatusText = "PrimaryCacheFiller Candidate";
                        break;
                    case 3:
                        cacheFillerStatusText = "AsyncCacheFiller Candidate";
                        break;
                    case 4:
                        cacheFillerStatusText = "AsyncCacheFiller";
                        break;
                }
                _logger.Debug("{0}.{1}() Executed for {2} In {3} ms and was the {4}", cacheMetaInfo.ClassName, cacheMetaInfo.MethodName, cacheMetaInfo.CacheKey, sw.ElapsedMilliseconds, cacheFillerStatusText);
            }
#endif

            return (result);
        }

        #region Internal and Private methods
        private T GetData<T>(Func<T> codeBlock, string apiURL, object postedData = null)
        {
            T result = default(T);

            if (GlobalAppConfigs.UseDataAPI && !string.IsNullOrEmpty(apiURL))
            {
                try
                {
                    result = GetDataUsingAPI(codeBlock, apiURL, postedData);
                }
                catch // If API call failed
                {
                    // ideally local executions should not fail
                    // thats why no exception handling on this
                    result = codeBlock();
                }
            }
            else
            {
                // Execute the code block on the local machine
                // ideally local executions should not fail
                // thats why no exception handling on this
                result = codeBlock();
            }

            return (result);
        }

        private bool IsReadyForAsyncCall(string masterCacheKey, int asyncAfterSecs)
        {
            string cacheKey = string.Format("{0}_AsyncAfterSecs_{1}", masterCacheKey, asyncAfterSecs);
            bool result = true;

            // If the cache has an async timeout has not expired
            if (DataCacheInstance.ContainsKey(cacheKey))
            {
                result = false;
            }

            return (result);
        }

        private string GetResetAsyncCacheKey(string masterCacheKey, int afterAsyncTime)
        {
            return string.Format("{0}_AsyncAfterSecs_{1}", masterCacheKey, afterAsyncTime);
        }

        private void ResetAsyncPeriod(string masterCacheKey, int asyncAfterSecs)
        {
            string cacheKey = string.Format("{0}_AsyncAfterSecs_{1}", masterCacheKey, asyncAfterSecs);

            DataCacheInstance.RemoveEntry(cacheKey);
            DataCacheInstance.SetData(cacheKey, "1", asyncAfterSecs);
        }
        #endregion

        #region API Methods
        private T GetDataUsingAPI<T>(Func<T> codeBlock, string apiURL, object postedData = null)
        {
            T result = default(T);

            try
            {
                apiURL = string.Format("{0}/{1}", GlobalAppConfigs.RESTAPIURL, apiURL);


                var httpWebRequest = (HttpWebRequest)WebRequest.Create(apiURL);

                if (postedData != null)
                {
                    httpWebRequest.ContentType = "application/x-www-form-urlencoded";//"text/json";
                    httpWebRequest.Method = "POST";

                    //We need to count how many bytes we're sending. Post'ed Faked Forms should be name=value&
                    string param = JsonConvert.SerializeObject(postedData);
                    byte[] bytes = System.Text.Encoding.ASCII.GetBytes(param);
                    httpWebRequest.ContentLength = bytes.Length;

                    using (var ios = httpWebRequest.GetRequestStream())
                    {
                        ios.Write(bytes, 0, bytes.Length); //Push it out there
                        ios.Flush();
                        ios.Close();
                    }
                }
                else
                {
                    httpWebRequest.ContentType = "text/json";
                    httpWebRequest.Method = "GET";
                }

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var responseText = streamReader.ReadToEnd();

                    result = JsonConvert.DeserializeObject<T>(responseText);
                }
            }
            catch (Exception ex)
            {

                throw;
            }

            return result;
        }
        #endregion

        #region Cache Configurations Method(s)

        private CacheKeyAndMasterKey GenerateCacheKey(Delegate[] list, StackFrame frame, bool IsManualKey, string apiName)
        {
            // TODO: Once the implementation has moved to HashCodes, then or each key generated we will need to check if a corresponding hashcode exists in the cache, if so then we will need to append a numeric sequence to uniquify it 
            //          and recursively check again. (this logic still might fail as hashkeys are not reversable)
            // Some Hashing References
            // http://programmers.stackexchange.com/questions/49550/which-hashing-algorithm-is-best-for-uniqueness-and-speed
            // http://landman-code.blogspot.ae/2009/02/c-superfasthash-and-murmurhash2.html
            // http://stackoverflow.com/questions/8820399/c-sharp-4-0-how-to-get-64-bit-hash-code-of-given-string
            // NOTE: So I checked, moving the imp to hash codes will not really effect the time to search for a cache key in the cache

            // TODO: Instead of generating the keys each time there should be a lookup first for already generated keynames against the data coming in

            // PARAMETERS 
            //1-Delegate[] list: it will give codeblock's method parameters and their datatype. By using reflection values can be retrieved from this list. 
            //2-StackFrame frame: it will give name and class name of method using cache. 

            //it will get the method name on which cache is applied.
            var method = frame.GetMethod();

            string cacheKey = string.Empty;
            string cacheKeyPlaceholder = string.Empty;
            string masterKey = string.Empty;
            string format = string.Empty;
            string paramNames = string.Empty;
            string paramValues = string.Empty;

            //it will get the name of class in which method having cahce is present.
            string className = method.ReflectedType.Name.ToUpper();
            string methodName = method.Name.ToUpper();

            if (list != null & list.Length > 0)
            {
                //STEP1: Cache key generation start from here  i.e CK_ARTICLESERVICE_GETARTICLE
                cacheKey = string.Format("CK_{0}_{1}_{2}", className, methodName, apiName);
                int counter = 0;
                foreach (var delegateList in list)
                {
                    if (delegateList != null)
                    {
                        if (delegateList.Target != null)
                        {
                            // this function will loop through each parameter
                            foreach (var field in delegateList.Target.GetType().GetFields())
                            {
                                if (!field.Name.Contains("this") && !field.Name.Contains("<") && !field.Name.Contains(">") && !field.Name.Contains("context"))
                                {
                                    //STEP2: Cache key generation, it will concate all the parameters of method having cache.
                                    paramNames = string.Format("{0}_{1}", paramNames, field.Name.ToUpper());
                                    if (field.FieldType.Namespace.ToLower().Trim() == "System.Collections.Generic".ToLower().Trim() || field.FieldType.IsArray)
                                    {
                                        string itemClassFullName = field.FieldType.ToString().Substring(field.FieldType.ToString().IndexOf("[") + 1, field.FieldType.ToString().IndexOf("]") - (field.FieldType.ToString().IndexOf("[") + 1));
                                        if (field.GetValue(delegateList.Target) == null)
                                        {
                                            //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.
                                            paramValues = string.Format("{0}_", paramValues);
                                        }
                                        else
                                        {
                                            // this will handle List<>
                                            IList items = field.GetValue(delegateList.Target) as IList;

                                            if (items != null && items.Count > 0)
                                            {
                                                string paramVal = string.Empty;

                                                foreach (var item in items)
                                                {
                                                    if (item.GetType().IsPrimitive || item.GetType() == typeof(Decimal) || item.GetType() == typeof(String))
                                                    {
                                                        //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.

                                                        paramVal = string.Format("{0}_{1}", paramVal, item);
                                                    }
                                                    else
                                                    {
                                                        foreach (var prop in item.GetType().GetProperties())
                                                        {
                                                            //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.

                                                            paramVal = string.Format("{0}_{1}", paramVal, prop.GetValue(item, null));
                                                        }
                                                    }
                                                }
                                                //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.

                                                paramValues = string.Format("{0}_{1}", paramValues, paramVal);
                                            }
                                            else
                                            {
                                                IDictionary dictionaryItems = field.GetValue(delegateList.Target) as IDictionary;
                                                if (dictionaryItems != null && dictionaryItems.Count > 0)
                                                {
                                                    string paramVal = string.Empty;

                                                    foreach (var key in dictionaryItems.Keys)
                                                    {
                                                        paramVal += string.Format("{0}_{1}", key.ToString().ToUpper(), dictionaryItems[key.ToString()]);
                                                    }
                                                    //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.

                                                    paramValues = string.Format("{0}_{1}", paramValues.SanitizeString(), paramVal);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        //STEP3: Cache key generation, it will concate all the values of parameters of method having cache.

                                        paramValues = string.Format("{0}_{1}", paramValues, (field.GetValue(delegateList.Target) == null ? "NULL" : field.GetValue(delegateList.Target).ToString()));
                                    }
                                    //STEP4: Cache key generation, Format of cache key is generated.
                                    format = string.Format("{0}_{1}", format, "{" + counter + "}");
                                    //STEP5: Cache key generation, Place holder of cache key is generated.
                                    cacheKeyPlaceholder = string.Format("{0}_PH{1}", cacheKeyPlaceholder, counter);
                                    counter++;
                                }
                            }
                        }
                    }
                }
                if (!string.IsNullOrEmpty(paramValues))
                {
                    paramValues = paramValues.Replace("/", "").Replace("-", "").Replace("~", "").Replace(@"\", "");
                }
                //STEP4: Cache key Format Finalize here
                format = string.Format("{0}{1}{2}", cacheKey, paramNames, format);
                //STEP5: Cache key placeholder Finalize here
                cacheKeyPlaceholder = string.Format("{0}{1}{2}", cacheKey, paramNames, cacheKeyPlaceholder);
                // Cache Master Key
                masterKey = string.Format("{0}{1}", cacheKey, paramNames);
                //STEP3: Cache Data Key Finalize here
                cacheKey = string.Format("{0}{1}{2}", cacheKey, paramNames, paramValues);

                #region  CacheConfiguration object is of NO USE NOW.

                //CacheConfiguration object values is ready here.
                //CacheConfiguration cacheConfiguration = new CacheConfiguration();
                //cacheConfiguration.CacheKey = cacheKeyPlaceholder;
                //cacheConfiguration.ClassName = className;
                //cacheConfiguration.MethodName = methodName;
                //cacheConfiguration.Format = format;
                //cacheConfiguration.MasterKey = masterKey;
                ////cacheConfiguration.Duration = !string.IsNullOrEmpty(GlobalAppConfigs.DefaultInMemoryCacheTime) ? short.Parse(GlobalAppConfigs.DefaultInMemoryCacheTime) : short.Parse("900");
                //// cacheConfiguration.AsyncUpdate = !string.IsNullOrEmpty(GlobalAppConfigs.DefaultMemoryAsychUpdateTime) ? short.Parse(GlobalAppConfigs.DefaultMemoryAsychUpdateTime) : short.Parse("120");
                //cacheConfiguration.Duration = 900;
                //cacheConfiguration.AsyncUpdate = 120;
                //cacheConfiguration.IsActive = true;
                //cacheConfiguration.IsAPIActive = false;
                //cacheConfiguration.CreatedOn = DateTime.Now;
                //cacheConfiguration.IsManual = IsManualKey;
                //if (cacheConfiguration.IsManual == true)
                //{
                //    cacheConfiguration.Duration = 900;
                //    cacheConfiguration.AsyncUpdate = 120;
                //}
                //if (cacheConfiguration.CacheKey == "CK_CACHECONFIGURATIONS_CACHEKEYS")
                //{
                //    cacheConfiguration.Duration = 900;
                //    cacheConfiguration.AsyncUpdate = 300;
                //}
                #endregion
                // NOTE: Cos the imp of AddCacheKey is commented !
                //AsyncMethodCaller asyncMethod = new AsyncMethodCaller(AddCacheKey);
                //IAsyncResult result = asyncMethod.BeginInvoke(cacheConfiguration, null, null);
            }

            CacheKeyAndMasterKey obj = new CacheKeyAndMasterKey();
            obj.CacheKey = cacheKey;
            obj.MasterKey = masterKey;
            obj.ClassName = className;
            obj.MethodName = methodName;
            obj.ParamNames = paramNames;
            obj.ParamValues = paramValues;

            return (obj);
        }

        static public Type GetDeclaredType<TSelf>(TSelf self)
        {
            return typeof(TSelf);
        }

        static public List<TSelf> GeList<TSelf>(TSelf self)
        {
            return new List<TSelf>();
        }

        #endregion

        #region
        public List<string> GetAllChachedKeys()
        {
            return InMemoryDataCache.Instance.GetAllCacheKeys();
        }

        class CacheKeyAndMasterKey
        {
            public string CacheKey { get; set; }
            public string MasterKey { get; set; }

            public string ClassName { get; set; }
            public string MethodName { get; set; }
            public string ParamNames { get; set; }
            public string ParamValues { get; set; }
        }

        #endregion
    }
}
