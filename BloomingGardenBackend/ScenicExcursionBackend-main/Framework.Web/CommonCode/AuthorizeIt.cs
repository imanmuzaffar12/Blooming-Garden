using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Mvc;
using Framework.Web.CommonCode.Helpers;
namespace Framework.Web.CommonCode
{
    public class AuthorizeIt : System.Web.Mvc.AuthorizeAttribute
    {
        protected override bool AuthorizeCore(System.Web.HttpContextBase httpContext)
        {
            if (Authentication.Instance.IsLoggedIn)
            {
                if (string.IsNullOrEmpty(this.Roles))
                {
                    //Only Login is required....and the user is logged in....
                    return true;
                }
                foreach (string role in this.Roles.Split(",".ToCharArray()))
                {
                    if (Authentication.Instance.UserRoles.Contains(role))
                    {
                        return true; //User Role is mentioned...
                    }
                }
                Authentication.Instance.LastSecurityError = "Role is not assigned to the user";
                return false;
            }
            return false;
        }

         protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
         {

             RedirectToRouteResult result = null;
             if (Authentication.Instance.IsLoggedIn)
             {
                 Authentication.Instance.LastSecurityError = "Role is not assigned to the user";
                 result = new RedirectToRouteResult("HomePage", new System.Web.Routing.RouteValueDictionary(), true);
             }
             else
             {
                 result = new RedirectToRouteResult("LoginRoute", new System.Web.Routing.RouteValueDictionary(), true);
             }
             
             filterContext.Result = result;
         }
    }
}