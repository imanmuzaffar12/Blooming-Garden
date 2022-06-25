using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Framework.Shared.WebAttributes
{
    public class HTTPException404Attribute : ActionFilterAttribute
    {
        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            if (///filterContext.Exception.GetType() == typeof(Exception) && 
				filterContext.Controller.ViewData.Model == null && filterContext.Exception == null)
            {
                throw new HttpException(404, filterContext.RequestContext.HttpContext.Request.Url.ToString());
            }

            base.OnActionExecuted(filterContext);
        }
    }
}