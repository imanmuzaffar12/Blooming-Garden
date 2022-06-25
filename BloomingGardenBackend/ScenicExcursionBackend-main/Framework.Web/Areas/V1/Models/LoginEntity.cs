using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Cryptofy.Areas.V1.Models
{
    public class LoginEntity
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string RememberMe { get; set; }
    }

    public class RegistrationForm
    {
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; } 
        public string Password { get; set; }
    }

    public class SocialLoginEntity
    {
        private string _usernameoremail;
        public string Usernameoremail { get { return _usernameoremail ?? string.Empty; } set { _usernameoremail = value; } }
        private string _fullname;
        public string Fullname { get { return _fullname ?? string.Empty; } set { _fullname = value; } }
        private string _providername;
        public string Providername { get { return _providername ?? string.Empty; } set { _providername = value; } }
        private string _provideruserid;
        public string Provideruserid { get { return _provideruserid ?? string.Empty; } set { _provideruserid = value; } }
        private string _profilepicurl;
        public string Profilepicurl { get { return _profilepicurl ?? string.Empty; } set { _profilepicurl = value; } }
    }

    public class UserEntity
    {
        public string Status { get; set; } = string.Empty;
        public string UserID { get; set; } = string.Empty;
        public string DisplayName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string PictureURL { get; set; } = string.Empty;
        public string PictureCreativeURL { get; set; } = string.Empty;
        public string ErrorMsg { get; set; } = string.Empty;
    }
}