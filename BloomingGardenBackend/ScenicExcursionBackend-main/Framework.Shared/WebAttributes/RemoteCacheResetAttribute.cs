using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Framework.Shared.WebAttributes
{
    public class RemoteCacheResetAttribute : ActionFilterAttribute
    {
        public string CacheKey { get; set; }

        private delegate void CacheResetDelegateWithoutParameters();

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            #region Sample code
            //if (CacheKey.Equals(CacheKeys.CK_CACHEABLEUSER))
            //{
            //    CacheKey = CacheKey + AuthenticationHelper.SessionSecurityContextInstance.UserID;
            //}

            //CacheResetDelegateWithoutParameters cacheResetDelegate = new CacheResetDelegateWithoutParameters(ResetCache);
            //AsyncCallback ac = new AsyncCallback(ResetCacheCallBack);
            //cacheResetDelegate.BeginInvoke(ac, cacheResetDelegate);
            #endregion

            base.OnActionExecuted(filterContext);
        }

        private void ResetCache()
        {
            #region Sample code
            //string uriToHit = string.Format(ConfigurationManager.AppSettings["CacheLiasionURL"], CacheKey);

            //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uriToHit);
            //HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            //response.Close();
            #endregion
        }

        private void ResetCacheCallBack(IAsyncResult ar)
        {
            #region Sample code
            //// first case IAsyncResult to an AsyncResult object, so we can get the
            //// delegate that was used to call the function.
            //AsyncResult result = (AsyncResult)ar;

            //CacheResetDelegateWithoutParameters del =
            //    (CacheResetDelegateWithoutParameters)result.AsyncDelegate;

            //try
            //{
            //    del.EndInvoke(ar);
            //}
            //catch (Exception ex)
            //{
            //    Logger.WriteDebug(string.Concat("CacheReset Failed:", ex.Message));
            //}
            #endregion
        }
    }
}