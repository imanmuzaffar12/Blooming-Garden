using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Framework.Web
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute(
               name: "LoginRoute", //Don't change this name it is used for Authorize Attributes
               url: "login",
               defaults: new { controller = "Authentication", action = "Login" }
            );
            routes.MapRoute(
               name: "ForgotPassword", //Don't change this name it is used for Authorize Attributes
               url: "forgot-password",
               defaults: new { controller = "Authentication", action = "ForgotPassword" }
            );
            routes.MapRoute(
               name: "LoginRouteDirect", //Don't change this name it is used for Authorize Attributes
               url: "",
               defaults: new { controller = "Authentication", action = "Login" }
            );
            routes.MapRoute(
               name: "HomePage",  //Don't change this name it is used for Authorize Attributes
               url: "home",
               defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
           );
            routes.MapRoute(
               name: "DynamicSetupScreen",  //Don't change this name it is used for Authorize Attributes
               url: "admin/{moduleName}/{screenName}",
               defaults: new { controller = "Configuration", action = "DynamicSetupScreen", screenID = UrlParameter.Optional }
            );
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}