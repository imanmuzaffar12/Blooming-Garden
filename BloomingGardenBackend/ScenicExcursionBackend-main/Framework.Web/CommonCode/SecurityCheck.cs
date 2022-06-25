using Framework.Application.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace Framework.Web.CommonCode
{
    public class SecurityCheck : AuthorizeAttribute
    {
        public const string DEVICE_TOKEN = "DeviceToken";
        public const string USER_ID = "UserID";
        public const string PASSWORD = "Password";
        private const string ERROR_DEVICETOKEN = "Unauthorized: DeviceToken is missing or invalid.";
        private const string ERROR_USERID = "Unauthorized: UserID was missing or incorrect.";
        private const string ERROR_USERIDANDPASSWORD = "Unauthorized: UserID and Password was missing or incorrect.";
        private const string ERROR_PASSWORD = "Unauthorized: Password was missing or incorrect.";
        public bool DeviceToken { get; set; }
        public bool UserId { get; set; }
        public bool Password { get; set; }
        public bool IsAuthorized { get; set; }
        public string ErrorMessage { get; set; }
        public int StatusCode { get; set; }
        public string Version { get; set; }

        public SecurityCheck(bool deviceToken, bool userId, bool password, string version = "")
        {
            this.Password = password;
            this.UserId = userId;
            this.DeviceToken = deviceToken;
            this.Version = version;
        }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            try
            {
                this.IsAuthorized = true;

                if (this.DeviceToken)
                {
                    this.IsAuthorized = (!string.IsNullOrEmpty(httpContext.Request.Headers[DEVICE_TOKEN]));
                    string deviceToken = httpContext.Request.Headers[DEVICE_TOKEN];
                    bool isDeviceTokenValid = false;

                    if (!string.IsNullOrEmpty(this.Version) && this.Version == "v1.2")
                    {
                        try
                        {
                            //removing validation due to issues with Android GCM device token generation.
                            isDeviceTokenValid = true;//Argaam.FM.PushNotifications.Client.NotificationClient.Instance.VerifyDevice(deviceToken, Common.GetPlatformApplicationArn(deviceToken));
                        }
                        catch (Exception) { }
                    }
                    //else
                    //{
                    //    isDeviceTokenValid = this.IsAuthorized ? CommonServices.IsDeviceRegistered(httpContext.Request.Headers[DEVICE_TOKEN], (int)ApplicationType.ArgaamMobile) : this.IsAuthorized;
                    //}

                    this.IsAuthorized = this.IsAuthorized ? isDeviceTokenValid : this.IsAuthorized;

                    if (!this.IsAuthorized)
                    {
                        this.StatusCode = 500;
                        this.ErrorMessage = ERROR_DEVICETOKEN;
                    }
                }

                if (this.UserId && this.IsAuthorized)
                {
                    this.IsAuthorized = (!string.IsNullOrEmpty(httpContext.Request.Headers[USER_ID]));
                    int userId = 0;
                    if (!this.IsAuthorized || !int.TryParse(httpContext.Request.Headers[USER_ID], out userId) || !UserServices.Instance.IsUserIDExist(userId))
                    {
                        this.StatusCode = 500;
                        this.ErrorMessage = ERROR_USERID;
                        this.IsAuthorized = false;
                    }
                }

                if (this.Password && IsAuthorized)
                {
                    this.StatusCode = 500;
                    this.IsAuthorized = (!string.IsNullOrEmpty(httpContext.Request.Headers[PASSWORD]));
                    this.ErrorMessage = !this.IsAuthorized ? ERROR_PASSWORD : "";
                }

                if (this.UserId && this.Password && IsAuthorized)
                {
                    this.IsAuthorized = ((!string.IsNullOrEmpty(httpContext.Request.Headers[USER_ID])) && (!string.IsNullOrEmpty(httpContext.Request.Headers[PASSWORD])));
                    if (IsAuthorized)
                    {
                        int userId = 0;
                        //int userID = CommonServices.GetMappedID(new Guid(httpContext.Request.Headers[USER_ID]));
                        if (int.TryParse(httpContext.Request.Headers[USER_ID], out userId) && !UserServices.Instance.IsUserIDExist(userId))
                        {
                            this.StatusCode = 500;
                            this.ErrorMessage = ERROR_USERID;
                            this.IsAuthorized = false;
                        }
                    }
                    else
                    {
                        this.StatusCode = 500;
                        this.ErrorMessage = ERROR_USERIDANDPASSWORD;
                    }
                }

                if (IsAuthorized)
                {
                    //Common.UserID = !string.IsNullOrEmpty(httpContext.Request.Headers[USER_ID]) ? int.Parse(httpContext.Request.Headers[USER_ID]) : 0;
                    //Common.DeviceToken = !string.IsNullOrEmpty(httpContext.Request.Headers[DEVICE_TOKEN]) ? httpContext.Request.Headers[DEVICE_TOKEN] : string.Empty;
                    return true;
                }
                    
            }
            catch (Exception ex)
            {
                this.IsAuthorized = false;
                this.StatusCode = 500;
                this.ErrorMessage = ex.Message;
                return false;
            }

            return base.AuthorizeCore(httpContext);

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