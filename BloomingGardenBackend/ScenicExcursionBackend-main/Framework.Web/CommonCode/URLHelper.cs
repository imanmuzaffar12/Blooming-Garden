using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Routing;
using System.Web.Mvc;

namespace Adoofy.CommonCode
{
    public static class CustomURLHelper
    {
        public static int maxLengthContent = 128;

        public static string GetRouteURL(this UrlHelper helper)
        {
            string routeURL = ((System.Web.Routing.Route)(System.Web.HttpContext.Current.Request.RequestContext.RouteData.Route)).Url;
            return routeURL;
        }

        public static bool IsImageURL(string Url)
        {
            bool retVal = false;
            string[] imageExtnArray = { ".jpg", ".ico", ".gif", ".jpeg" };

            if (imageExtnArray.Any(s => Url.Contains(s)))
            {
                retVal = true;
            }

            return retVal;
        }

        public static string DisplayPicture(this UrlHelper helper, string imageURL)
        {
            string imagePath = string.Empty;
            if (!string.IsNullOrEmpty(imageURL))
            {
                imagePath = helper.Content(imageURL);
            }
            else
            {
                imagePath = string.Empty;
            }
            return imagePath;
        }
    }

}

