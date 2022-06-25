using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Framework.Shared.WebAttributes
{
    public class AllowRoleAttribute : AuthorizeAttribute
    {
        public string Role { get; set; }
        public string RedirectToURL { get; set; }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            #region sample code
            //if (AuthenticationHelper.IsUserLoggedIn && AuthenticationHelper.SessionSecurityContextInstance.UserRoles.Exists(m => m.RoleName.ToLower() == Role.ToLower()))
            //{
            //    return true;
            //}
            //else
            //{
            //    return false;
            //}
            #endregion

            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            #region sample code
            //if (string.IsNullOrEmpty(RedirectToURL))
            //{
            //    filterContext.Result = new RedirectResult((new UrlHelper(HttpContext.Current.Request.RequestContext)).Home());
            //}
            //else
            //{
            //    filterContext.Result = new RedirectResult(RedirectToURL);
            //}
            #endregion
        }
    }
}