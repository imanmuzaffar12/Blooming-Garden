using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;
using Cryptofy.Areas.V1.Models;
using System.Text.RegularExpressions;
using Framework.Application.Services;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
using Framework.Shared.DataServices;
using Framework.Shared.DataServices.CustomEntities;
using System.Web;
using System.IO;
using HttpPostAttribute = System.Web.Http.HttpPostAttribute;
using System.Drawing;
using System.Drawing.Imaging;
using ServiceStack.Text;
using Framework.Web.CommonCode.Helpers;
using System.Configuration;
using System.Threading.Tasks;
using System.IdentityModel.Tokens;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.IdentityModel.Claims;
using Framework.Web.CommonCode;
using Adoofy.CommonCode;

namespace Framework.Areas.V1.Controllers
{
    public class APIController : Controller
    {
        public static string APIBaseUrl = ConfigurationManager.AppSettings["APIBaseURL"].ToString();
        //[HelpDescription(typeof(Dictionary<string, string>), false, "Data", "DeviceToken", "POST")]
        //[HelpRegistrar("Scenic Excursion", typeof(Dictionary<string, object>))]
        //[FrameworkAuthorization]
        public APIActionResult Data(string resultType, string name, Dictionary<string, object> param, Dictionary<string, JsonObject> param1)
        {
            APIActionResult result = new APIActionResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            result.StatusCode = 200;
            result.StatusMessage = "Success";
            result.ActionType = (ActionTypeEnum)Enum.Parse(typeof(ActionTypeEnum), resultType, true);
            string data = string.Empty;
            if (name.ToLower() == "get-token")
            {
                result.Data = new string[0];
                result.Token = GetToken();
                result.IsAuthorized = false;
                return result;
            }
            if (name.ToLower() == "login" && param.Keys.Contains("ProviderName") && param.Keys.Contains("Token"))
            {
                name = "social-login";
            }
            if (param != null && param.Count != 0 && !param.Keys.Contains("controller"))
            {
                if (param.Keys.Contains("Password"))
                {
                    param["Password"] = param["Password"].ToString().Encrypt();
                }
                if (param.Keys.Contains("OldPassword"))
                {
                    param["OldPassword"] = param["OldPassword"].ToString().Encrypt();
                }
                if (param.Keys.Contains("NewPassword"))
                {
                    param["NewPassword"] = param["NewPassword"].ToString().Encrypt();
                }
                if (param.Values.Contains(" "))
                {
                    param["CategoryID"] = null;
                }
                if (param.Keys.Contains("ProfileUrlBase64") && param["ProfileUrlBase64"] != null)
                {
                    string url = string.Empty;
                    byte[] bytes = Convert.FromBase64String(
                        param["ProfileUrlBase64"].ToString()
                        .Replace("data:image/jpeg;base64,", "")
                        .Replace("data:image/png;base64,", "")
                        .Replace("data:image/jpg;base64,", "")
                        .Replace("data:image/gif;base64,", ""));
                    string fileName = string.Format("{0}.jpg", Guid.NewGuid().ToString());
                    using (Image image = Image.FromStream(new MemoryStream(bytes)))
                    {
                        string path = Path.Combine(Server.MapPath("~/Images"),
                                                       Path.GetFileName(fileName));
                        image.Save(path, ImageFormat.Jpeg);  // Or Png
                    }
                    url = APIBaseUrl + "/Images/" + fileName;
                    param.AddOrUpdate<string, object>("ProfileUrl", url);
                }
                data = CommonServices.Instance.GetAPI(name, param);
                try
                {
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = Int32.MaxValue;
                    object jsonData = j.Deserialize(data, typeof(object));
                    result.Data = jsonData;
                    if (name.Contains("login"))
                    {
                        result.Token = GetToken(data);
                    }
                    if (name.Contains("forgot-password"))
                    {
                        var user = jsonData as Dictionary<string, object>;
                        Task.Run(() => BroadcastHelper.SendEmailAsync(user["FullName"].ToString(), "Blooming Garden- Forgot Password", user["EmailAddress"].ToString(), user["Password"].ToString(), BroadcastHelper.ControlPanelUrl, string.Empty, string.Empty, string.Empty, "ForgotPassword"));
                    }
                }
                catch (Exception ex)
                {
                    result.StatusCode = 501;
                    result.StatusMessage = "Error";
                    result.StatusMessage = "An error is occured while processing your request.";
                    result.ErrorMessage = ex.Message;
                }
            }
            if (param1 != null && param1.Count != 0 && param1.Keys.Contains("JSON"))
            {
                param1 = SetMixin(param1);
                if (param1.Keys.Contains("JSON"))
                {
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = Int32.MaxValue;
                    param = new Dictionary<string, object>();
                    param["JSON"] = j.Serialize(param1["JSON"]);
                }
                string response = CommonServices.Instance.PostAPI(name, param);
                try
                {
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = Int32.MaxValue;
                    object jsonData = j.Deserialize(response, typeof(object));
                    if (name.Contains("register-user"))
                    {
                        result.Token = GetToken(response);
                        var json = param1["JSON"];
                        Task.Run(() => BroadcastHelper.SendEmailAsync(json["FullName"].ToString(), "Welcome to Blooming Garden", json["EmailAddress"].ToString(), json["Password"].ToString(), BroadcastHelper.ControlPanelUrl, string.Empty, string.Empty, string.Empty, "Registration"));
                    }
                    result.Data = jsonData;
                }
                catch (Exception ex)
                {
                    result.StatusCode = 501;
                    result.StatusMessage = "Error";
                    result.StatusMessage = "An error is occured while processing your request.";
                    result.ErrorMessage = ex.Message;
                }
            }
            result.IsAuthorized = true;
            return result;
        }
        private string GetToken(string response)
        {
            JavaScriptSerializer j = new JavaScriptSerializer();
            j.MaxJsonLength = Int32.MaxValue;
            object jsonData = j.Deserialize(response, typeof(object));
            string token = string.Empty;
            if (response != "[]")
            {
                var js = jsonData as Dictionary<string, object>;
                token = JwtManager.GenerateToken(js["UserID"].ToString());
            }
            return token;
        }
        private string GetToken()
        {
            string token = string.Empty;
            string userID = string.Empty;
            if (!string.IsNullOrEmpty(HttpContext.Request.Headers["UserID"]))
            {
                userID = HttpContext.Request.Headers["UserID"];
            }
            token = JwtManager.GenerateToken(userID);
            return token;
        }
        public Dictionary<string, JsonObject> SetMixin(Dictionary<string, JsonObject> param)
        {
            var mixin = param["JSON"];
            if (mixin.Keys.Contains("OldPassword"))
            {
                mixin["OldPassword"] = mixin["OldPassword"].ToString().Encrypt();
            }
            if (mixin.Keys.Contains("NewPassword"))
            {
                mixin["NewPassword"] = mixin["NewPassword"].ToString().Encrypt();
            }
            if (mixin.Keys.Contains("Password"))
            {
                mixin["Password"] = mixin["Password"].ToString().Encrypt();
            }
            if (mixin.Keys.Contains("EmailAddress"))
            {
                string path = Common.GetQrCode(mixin["EmailAddress"].ToString().Encrypt(), Request.Url.AbsoluteUri, Request.RawUrl);
                mixin.Add("QRCodeUrl", path);
            }
            mixin.Add("CreatedOn", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
            mixin.Add("CreatedBy", "1");
            mixin.Add("ModifiedOn", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
            mixin.Add("ModifiedBy", "1");
            mixin.Add("VerificationCode", Guid.NewGuid().ToString());
            mixin.Add("IsVerified", "false");
            mixin.Add("StatusID", "1");
            param["JSON"] = mixin;
            return param;
        }
        [HttpPost]
        public JsonResult UploadImage(HttpPostedFileBase file)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            string message = string.Empty;
            string filePath = string.Empty;
            if (file != null && file.ContentLength > 0)
                try
                {
                    string path = Path.Combine(Server.MapPath("~/Images"),
                                               Path.GetFileName(file.FileName));
                    file.SaveAs(path);
                    message = "File uploaded successfully";
                    filePath = path;
                }
                catch (Exception ex)
                {
                    message = "ERROR:" + ex.Message.ToString();
                }
            else
            {
                message = "You have not specified a file.";
            }
            result.Data = new { image = filePath.Replace("\\", "/"), message = message };
            return result;
        }
        public string SaveImage(string file)
        {
            string url = string.Empty;
            string filePath = string.Empty;
            try
            {
                string base64 = file.Replace("data:image/jpeg;base64,", "");
                byte[] bytes = Convert.FromBase64String(base64);
                string fileName = string.Format("{0}.jpg", Guid.NewGuid().ToString());
                using (Image image = Image.FromStream(new MemoryStream(bytes)))
                {
                    string path = Path.Combine(Server.MapPath("~/Images"),
                                                   Path.GetFileName(fileName));
                }
                url = "http://aseu.somee.com/images/" + fileName;
            }
            catch (Exception ex)
            {
                url = ex.Message;
            }
            return url;
        }
        [HttpPost]
        public APIActionResult UpdateProfilePhoto(FormCollection form)
        {
            APIActionResult result = new APIActionResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            int UserID = int.Parse(form["UserID"].ToString());
            string ProfileUrlBase64 = form["ProfileUrl"];
            result.StatusCode = 200;
            result.StatusMessage = "Success";
            result.ActionType = (ActionTypeEnum)Enum.Parse(typeof(ActionTypeEnum), "json", true);
            string data = string.Empty;
            string name = "update-profile-photo";
            Dictionary<string, object> param = new Dictionary<string, object>();
            if (!string.IsNullOrEmpty("ProfileUrlBase64"))
            {
                param.Add("UserID", UserID);
                string url = string.Empty;
                byte[] bytes = Convert.FromBase64String(
                    ProfileUrlBase64
                    .Replace("data:image/jpeg;base64,", "")
                    .Replace("data:image/png;base64,", "")
                    .Replace("data:image/jpg;base64,", "")
                    .Replace("data:image/gif;base64,", ""));
                string fileName = string.Format("{0}.jpg", Guid.NewGuid().ToString());
                using (Image image = Image.FromStream(new MemoryStream(bytes)))
                {
                    string path = Path.Combine(Server.MapPath("~/Images"),
                                                   Path.GetFileName(fileName));
                    image.Save(path, ImageFormat.Jpeg);  // Or Png
                }
                url = APIBaseUrl + "/Images/" + fileName;
                param.AddOrUpdate<string, object>("ProfileUrl", url);
            }
            data = CommonServices.Instance.GetAPI(name, param);
            try
            {
                JavaScriptSerializer j = new JavaScriptSerializer();
                j.MaxJsonLength = Int32.MaxValue;
                object jsonData = j.Deserialize(data, typeof(object));
                result.Data = jsonData;
            }
            catch (Exception ex)
            {
                result.StatusCode = 501;
                result.StatusMessage = "Error";
                result.StatusMessage = "An error is occured while processing your request.";
                result.ErrorMessage = ex.Message;
            }
            return result;
        }
    }
}