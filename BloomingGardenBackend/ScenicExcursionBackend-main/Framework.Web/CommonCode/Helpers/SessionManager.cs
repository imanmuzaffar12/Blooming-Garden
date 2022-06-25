using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Framework.Shared.DataServices;

namespace Framework.Web.CommonCode.Helpers
{
    public partial class SessionManager
    {
        public static void AbandonSession()
        {
            HttpContext.Current.Session.Abandon();

            // the following method make sure the seesion id is not reused. 
            HttpCookie mycookie = new HttpCookie("ASP.NET_SessionId");
            mycookie.Expires = DateTime.Now.AddDays(-1);
            HttpContext.Current.Response.Cookies.Add(mycookie);
        }
    }
}



