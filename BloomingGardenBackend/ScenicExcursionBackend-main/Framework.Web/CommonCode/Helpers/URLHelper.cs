using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Framework.Web.CommonCode.Helpers
{
    public static class CPURLHelper
    {
        public static string StyleSheet(this UrlHelper helper, string fileName)
        {
            return helper.Content(string.Format("~/content/{0}", fileName)).ToLower();
        }

        public static string Image(this UrlHelper helper, string imageName)
        {
            return helper.Content(string.Format("~/content/images/{0}", imageName)).ToLower();
        }

        public static string Script(this UrlHelper helper, string scriptFileName)
        {
            return helper.Content(string.Format("~/scripts/{0}", scriptFileName)).ToLower();
        }

        public static string ActiveMenuItem(this UrlHelper helper, string controllerName)
        {
            string controller = helper.RequestContext.RouteData.Values["controller"].ToString();
            if (controller.ToLower() == controllerName.ToLower())
            {
                return "active";
            }
            return "";
        }

        public static string ActiveMenuItem(this UrlHelper helper, string controllerName, string controllerName2)
        {
            string controller = helper.RequestContext.RouteData.Values["controller"].ToString();
            if (controller.ToLower() == controllerName.ToLower() || controller.ToLower() == controllerName2.ToLower())
            {
                return "active";
            }
            return "";
        }
    }
}