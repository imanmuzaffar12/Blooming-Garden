using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace Framework.Web.CommonCode
{
    public class APIActionResult : ActionResult
    {
        public Object Data { get; set; }
        public ActionTypeEnum ActionType { get; set; }
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }
        public string ErrorMessage { get; set; }
        public string Message { get; set; }
        public bool IsAuthorized { get; set; }
        public string Token { get; set; }
        public JsonRequestBehavior JsonRequestBehavior { get; set; }
        public override void ExecuteResult(ControllerContext context)
        {
            if (this.ActionType == ActionTypeEnum.JSON)
            {
                JsonResult result = new JsonResult();
                result.JsonRequestBehavior = this.JsonRequestBehavior;
                result.MaxJsonLength = Int32.MaxValue;
                Result res = new Result() { Data = this.Data, StatusCode = this.StatusCode, StatusMessage = this.StatusMessage, Token = this.Token, ErrorMessage = this.ErrorMessage, IsAuthorized = this.IsAuthorized, Message = this.Message };
                result.Data = res;
                result.ExecuteResult(context);
            }
            else if (this.ActionType == ActionTypeEnum.Help)
            {
                context.HttpContext.Response.Write("We Are working on help,,,, please wait.");
            }
        }
    }
    public class Result
    {
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }
        public string Message { get; set; }
        public object Data { get; set; }
        public bool IsAuthorized { get; set; }
        public string Token { get; set; }
        public string ErrorMessage { get; set; }
    }
    public enum ActionTypeEnum
    {
        JSON = 1,
        XML = 3,
        PList = 2,
        Help = 4
    }
}