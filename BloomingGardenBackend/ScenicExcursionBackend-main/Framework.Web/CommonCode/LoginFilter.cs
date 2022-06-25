using Cryptofy.Areas.V1.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Adoofy.CommonCode
{

    public class LoginFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            try
            {
                var userPostData = (LoginEntity)filterContext.ActionParameters["data"];
                filterContext.ActionParameters["data"] = new LoginEntity()
                {
                    Email = userPostData.Email,
                    Password = Common.EPassword(userPostData.Password),
                    RememberMe = userPostData.RememberMe
                };
            }
            catch { }
            try
            {
                var userPostData = (RegistrationForm)filterContext.ActionParameters["data"];
                filterContext.ActionParameters["data"] = new RegistrationForm()
                {
                    Email = userPostData.Email,
                    Password = Common.EPassword(userPostData.Password),
                    FirstName = userPostData.FirstName,
                    LastName = userPostData.LastName,
                    DisplayName = userPostData.DisplayName
                };
            }
            catch { }
            base.OnActionExecuting(filterContext);
        }
    }
}