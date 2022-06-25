using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Framework.Web.CommonCode;
using Framework.Application.Services;
using Framework.Application;

namespace Framework.Web.Controllers
{
    [AuthorizeIt]
    public class BaseController : Controller
    {
        /// <summary>
        /// Called before the action method is invoked.
        /// </summary>
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
        }
    }
}
