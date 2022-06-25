using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Framework.Web;
using Framework.Application.Services;
using Framework.Shared.DataServices;

namespace Framework.Web.CommonCode.Helpers
{
    public class Authentication
    {
        #region Define as Singleton
        
        public static Authentication Instance
        {
            get
            {
                return new Authentication();
            }
        }

        private Authentication()
        {
          //  HttpContext.Current.Session["LastErrorAuthorization"] = "";
        }
        #endregion
        public const string UserID = "BarNo";
        public const string MD5Hash= "BarHash";
        public static DateTime ExpireCookiesOn
        {
            get
            {
                return DateTime.Now.AddDays(4);
            }
        }
        public UserEntity User 
        {
            get
            {
                if (HttpContext.Current.Session["User"] == null)
                {
                    if (HttpContext.Current.Request.Cookies[UserID] != null && HttpContext.Current.Request.Cookies[MD5Hash] != null)
                    {
                        int userId = int.Parse(HttpContext.Current.Request.Cookies[UserID].Value);
                        string md5 = HttpContext.Current.Request.Cookies[MD5Hash].Value;
                        var user = AuthenticationServices.Instance.LoginUser(userId, md5);
                        HttpContext.Current.Session["User"] = user;
                        return user;
                    }
                    return null;
                }
                return (UserEntity)HttpContext.Current.Session["User"];
            }
            set
            {
                HttpContext.Current.Session.Add("User", value);
            }
        }
        public bool IsLoggedIn 
        {
            get
            {
                if (HttpContext.Current.Session["User"] == null)
                {
                    if (HttpContext.Current.Request.Cookies[UserID] != null && HttpContext.Current.Request.Cookies[MD5Hash] != null)
                    {
                        return true;
                    }
                    return false;
                }
                return true;
            }
        }

        /// <summary>
        /// Comma Seperated List of User Assigned Roles
        /// </summary>
        public string UserRoles
        {
            get
            {
                return "Admin";//
            }
        }
        public string LastSecurityError 
        {
            get
            {
                if (HttpContext.Current.Session["LastErrorAuthorization"] == null)
                {
                    HttpContext.Current.Session["LastErrorAuthorization"] = new Queue<string>();
                }
                Queue<string> queue = (Queue<string>)HttpContext.Current.Session["LastErrorAuthorization"];
                if(queue.Count > 0)
                    return queue.Dequeue();
                return "";
            }
            set
            {
                if (HttpContext.Current.Session["LastErrorAuthorization"] == null)
                {
                    HttpContext.Current.Session["LastErrorAuthorization"] = new Queue<string>();
                }
                Queue<string> queue = (Queue<string>)HttpContext.Current.Session["LastErrorAuthorization"];
                queue.Enqueue(value);
            }
        }
    }
}