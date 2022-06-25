using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Framework.Application.Services;
using Framework.Web.CommonCode.Helpers;
using Framework.Shared;
using Framework.Shared.DataServices;
using Framework.Shared.Enums;
using System.Web.Security;

namespace Framework.Web.Controllers
{
    public class AuthenticationController : Controller //This will not be inhirited from Base 
    {
        public ActionResult Login(FormCollection form)
        {
            Response.Cookies.Clear();
            Session.Clear();
            Session.RemoveAll();
            return View();
        }
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.Abandon(); // it will clear the session at the end of request
            return RedirectToAction("Login", "Authentication");
        }
        [HttpPost]
        public JsonResult LoginJSON(FormUser form)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            string emailAddress = form.EmailAddress;
            string password = form.Password;
            string rememberMe = form.RememberMe;
            var user = AuthenticationServices.Instance.LoginUser(emailAddress, password.Encrypt());
            if (user != null)
            {
                user.RolesRights = AuthenticationServices.Instance.GetUserRoleRights(user.UserID);
                if(user.RolesRights != null && user.RolesRights.Count != 0)
                {
                    user.RoleID = user.RolesRights.FirstOrDefault().RoleID;
                }
                if (user != null && rememberMe.ToLower() == "on")
                {
                    HttpCookie userId = new HttpCookie(Authentication.UserID, user.UserID.ToString());
                    userId.Expires = Authentication.ExpireCookiesOn;
                    Response.Cookies.Add(userId);
                    var md5Hash = new HttpCookie(Authentication.MD5Hash, user.MD5Hash);
                    md5Hash.Expires = Authentication.ExpireCookiesOn;
                    Response.Cookies.Add(md5Hash);
                    Authentication.Instance.User = user;
                    result.Data = new { Link = "/home/index", Message = "Successfully Logged In" };
                }
            }
            else
            {
                result.Data = new { Link = "Failed", Message = "Login failed, please try again with correct email & password." };
            }
            return result;
        }

        public ActionResult ForgotPassword()
        {
            if(Authentication.Instance.User == null)
            {
                return View();
            }
            else
            {
                return Redirect("/");
            }
        }
        public JsonResult ForgotPasswordEmail(string email)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            var user = CommonServices.Instance.GetUserByEmail(email);
            if (user != null)
            {
                var response = BroadcastHelper.SendEmail(user.FullName, "Blooming Garden - Forgot Password", user.EmailAddress, user.Password, BroadcastHelper.ControlPanelUrl, string.Empty, string.Empty, "ForgotPassword");
                if (response)
                {
                    result.Data = new { Message = "Email has been sent to your email address. Kindly check your mailbox!", Success = true };
                }
                else
                {
                    result.Data = new { Message = "Email has been failed to send. Kindly contact with the Administrator!", Success = false };
                }
            }
            else
            {
                result.Data = new { Message = "Email does not exists!", Success = false };
            }
            return result;
        }

        public class FormUser
        {
            public string EmailAddress { get; set; }
            public string Password { get; set; }
            public string RememberMe { get; set; }
        }
    }
}
