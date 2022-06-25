using Framework.Application.Services;
using Framework.Web.CommonCode;
using Glimpse.AspNet.Tab;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;


namespace Framework.Web.CommonCode
{
    public class FrameworkAuthorization : AuthorizeAttribute
    {
        public const string DEVICE_TOKEN = "DeviceToken";
        public const string USER_ID = "UserID";
        public const string PASSWORD = "Password";

        private const string ERROR_DEVICETOKEN = "Unauthorized: DeviceToken is missing or invalid.";
        private const string ERROR_USERID = "Unauthorized: UserID was missing or incorrect.";
        private const string ERROR_USERIDANDPASSWORD = "Unauthorized: UserID and Password was missing or incorrect.";
        private const string ERROR_PASSWORD = "Unauthorized: Password was missing or incorrect.";
        public string DeviceToken { get; set; }
        public string UserID { get; set; }
        public string Token { get; set; }
        public bool IsAuthorized { get; set; }
        public string ErrorMessage { get; set; }
        public int StatusCode { get; set; }
        public string Version { get; set; }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            try
            {
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Headers["UserID"]))
                {
                    this.UserID = HttpContext.Current.Request.Headers["UserID"];
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Headers["Token"]))
                {
                    this.Token = HttpContext.Current.Request.Headers["Token"];
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Headers["DeviceToken"]))
                {
                    this.DeviceToken = HttpContext.Current.Request.Headers["DeviceToken"];
                }
                if (httpContext.Request.Url.ToString().ToLower().Contains("/register-user") || httpContext.Request.Url.ToString().ToLower().Contains("/login") || httpContext.Request.Url.ToString().ToLower().Contains("/countries") || httpContext.Request.Url.ToString().ToLower().Contains("/cities") || httpContext.Request.Url.ToString().ToLower().Contains("/get-token") || httpContext.Request.Url.ToString().ToLower().Contains("/check-email") || httpContext.Request.Url.ToString().ToLower().Contains("/get-allresources") || httpContext.Request.Url.ToString().ToLower().Contains("/forgot-password"))
                {
                    return true;
                }
                var token = JwtManager.ValidateToken(Token);
                if (token != null && UserID.Equals(token.UserID))
                {
                    if (token.Expiration <= DateTime.Now)
                    {
                        this.ErrorMessage = "Token is expired";
                        this.IsAuthorized = false;
                        this.StatusCode = 401;
                        return false;
                    }
                    else
                    {
                        this.IsAuthorized = true;
                        this.StatusCode = 200;
                        return true;
                    }
                }
                else
                {
                    this.IsAuthorized = false;
                    this.StatusCode = 401;
                    this.ErrorMessage = "Incorrect Token";
                    return false;
                }
            }
            catch (Exception ex)
            {
                this.IsAuthorized = false;
                this.StatusCode = 500;
                this.ErrorMessage = ex.Message;
                return false;
            }
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            APIActionResult bzResult = new APIActionResult();
            bzResult.ActionType = (ActionTypeEnum)Enum.Parse(typeof(ActionTypeEnum), "json", true);
            bzResult.StatusCode = this.StatusCode;
            bzResult.StatusMessage = this.ErrorMessage;
            filterContext.Result = bzResult;
        }

    }
}