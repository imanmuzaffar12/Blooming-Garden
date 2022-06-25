using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Framework.Shared.WebAttributes
{
    public class ValidateRemoteRequestAttribute : AuthorizeAttribute
    {
        public string ConfigurationKey { get; set; }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            #region sample code
            //string[] allowedCallSource = ContentServices.GetConfigurationValue(ConfigurationKey).Split('|');
            //string requestingClientIP = LocationHelper.GetClientIPAddress();

            //Logger.WriteDebug("Requesting Client IP: " + requestingClientIP);
            //Logger.WriteDebug("Allowed Request Sources: " + ContentServices.GetConfigurationValue(ConfigurationKey));

            //if (allowedCallSource.Contains(requestingClientIP))
            //{
            //    Logger.WriteDebug("In PP:Requesting Client Validated: " + requestingClientIP);
            //    return true;
            //}
            //else
            //{
            //    Logger.WriteDebug("In PP:Requesting Client Not Validated: " + requestingClientIP);
            //    return false;
            //}
            #endregion

            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new System.Web.Mvc.HttpStatusCodeResult(403);
        }
    }
}