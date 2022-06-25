
using Framework.Shared.DataServices;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace Framework.Shared.Helpers
{
    /// <summary>
    /// Exception Logging Helper
    /// 
    /// This class has been kept here cos logically it should be in Basketo.Shared but as it uses
    ///     PetaPoco I need to keep it here. However I have kept it in the Shared namespace.
    /// </summary>
    public class ELHelper
    {
        public ELHelper()
        {
            _aeData = new Dictionary<string, object>();
        }

        const string SOURCE_APP_KEY = "ELHelper_SourceApp";
        const string LAST_SQL_KEY = "LastSqlQuery";
        const string WARNING = "W";
        const string ERROR = "E";
        Dictionary<string, object> _aeData;

        public void LogException(Exception theEx, string customMessage = null)
        {
            ELHelper elh = new ELHelper();

            try
            {
                using (FrameworkRepository repository = DataContextHelper.GetExceptionLoggingDataContext())
                {
                    repository.ELHelperInstance = elh;

                    //AppException appEx = new AppException()
                    //{
                    //    SourceApp = System.Configuration.ConfigurationManager.AppSettings[SOURCE_APP_KEY],
                    //    Message = theEx.Message,
                    //    OriginatedAt = theEx.TargetSite != null ? theEx.TargetSite.ReflectedType + "." + theEx.TargetSite.Name + "()" : "UNKNOWN",
                    //    StackTrace = theEx.StackTrace,
                    //    InnerExceptionMessage = theEx.InnerException != null ? theEx.InnerException.Message : null,
                    //    HostMachine = System.Environment.MachineName,
                    //    OccuredOn = DateTime.Now,
                    //    CustomMessage = customMessage,
                    //    Level = ERROR
                    //};

                    //repository.Insert(appEx);

                    foreach (KeyValuePair<string, object> adEntry in _aeData)
                    {
                        //AppExceptionAdditionalDatum aead = new AppExceptionAdditionalDatum()
                        //{
                        //    AppExceptionID = appEx.AppExceptionID,
                        //    Variable = adEntry.Key,
                        //    Value = adEntry.Value.ToString(),
                        //};

                        //repository.Insert(aead);
                    }
                }
            }
            catch (Exception ex)
            {
                // Ok this sucks. and should never happen...
                throw(new ApplicationException("You must setup Exception Logging properly, check \"ELHelper_SourceApp\" Key in the app.config or web.config AND also check if \"ELConnectionString\" is properly defined."));
            }
        }

        public void LogWarning(string customMessage = null)
        {
            ELHelper elh = new ELHelper();

            try
            {
                using (FrameworkRepository repository = DataContextHelper.GetExceptionLoggingDataContext())
                {
                    repository.ELHelperInstance = elh;

                    //AppException appEx = new AppException()
                    //{
                    //    SourceApp = System.Configuration.ConfigurationManager.AppSettings[SOURCE_APP_KEY],
                    //    Message = customMessage,
                    //    OriginatedAt = null,
                    //    StackTrace = null,
                    //    InnerExceptionMessage = null,
                    //    HostMachine = System.Environment.MachineName,
                    //    OccuredOn = DateTime.Now,
                    //    CustomMessage = customMessage,
                    //    Level = WARNING
                    //};

                    //repository.Insert(appEx);
                }
            }
            catch (Exception ex)
            {
                // Ok this sucks. and should never happen...
                throw (new ApplicationException("You must setup Exception Logging properly, check \"ELHelper_SourceApp\" Key in the app.config or web.config AND also check if \"ELConnectionString\" is properly defined."));
            }
        }

        public void AddVariable<T>(Expression<Func<T>> expr)
        {
            _aeData.AddOrUpdate(((MemberExpression)expr.Body).Member.Name, expr.Compile().Invoke());
        }

        public void AddVariable(string variableName, object value)
        {
            _aeData.AddOrUpdate(variableName, value);
        }

        public void AddLastExecutedPetapocoSql(PetaPoco.Sql lastSql)
        {
            StringBuilder sb = new StringBuilder(lastSql.SQL);

            for (int i = 0; i < lastSql.Arguments.Count(); i++)
            {
                Type t = lastSql.Arguments[i].GetType();

                if (t.Name == "String")
                {
                    sb.Replace("@" + i, "'" + lastSql.Arguments[i] + "'");
                }
                else
                {
                    sb.Replace("@" + i, lastSql.Arguments[i].ToString());
                }
                // TODO: Check for DateTime type also
            }

            _aeData.AddOrUpdate(LAST_SQL_KEY, sb.ToString());
        }

        public void AddLastExecutedSql(string lastSql)
        {
            _aeData.AddOrUpdate(LAST_SQL_KEY, lastSql);
        }
    }
}
