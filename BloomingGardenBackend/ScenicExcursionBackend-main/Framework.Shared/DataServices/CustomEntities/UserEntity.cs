using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Framework.Shared.Enums;
using PetaPoco;
using Basketo.Shared;


namespace Framework.Shared.DataServices
{
    public class UserEntity
    {
        public UserEntity()
        {
            
        }
        [ResultColumn]
        public int UserID { get; set; }
        [ResultColumn]
        public string EmailAddress { get; set; }
        [ResultColumn]
        public string FullName { get; set; }
        [ResultColumn]
        public string ProfileUrl { get; set; }
        [ResultColumn]
        public bool IsCPUser { get; set; }
        [ResultColumn]
        public string MobileNo { get; set; }
        [ResultColumn]
        public string ReasonForDeactivation { get; set; }
        [ResultColumn]
        public short RecordStatus { get; set; }
        string password;
        public string MD5Hash
        {
            get
            {
                return this.password.Decrypt().ToMD5Hash();
            }
        }
        [ResultColumn]
        public string Password
        {
            set
            {
                password = value;
            }
        }
        [ResultColumn]
        public int TotalRecords { get; set; }
        [ResultColumn]
        public int SubscriptionPackageID { get; set; }
        [ResultColumn]
        public int PackageDurationInDays { get; set; }
        [ResultColumn]
        public int DownloadQuota { get; set; }
        [ResultColumn]
        public int DownloadFrequency { get; set; }
        [ResultColumn]
        public int? DownloadCount { get; set; }
        [ResultColumn]
        public DateTime? LastDownloadOn { get; set; }
        [ResultColumn]
        public int UserSubscriptionID { get; set; }
        [ResultColumn]
        public DateTime EndsOn { get; set; }
        [ResultColumn]
        public string SessionID { get; set; }
        public List<UserRoleRightsEntity> RolesRights { get; set; }
        [ResultColumn]
        public int RoleID { get; set; }

    }

    public class PPUserEntity : User
    {
        public string Password { get; set; }
        public int CountryID { get; set; }
        public string CountryName { get; set; }
        public bool IsApproved { get; set; }
        public bool IsLockedOut { get; set; }
        public List<UserRoleEntity> UserRoles { get; set; }

        [ResultColumn]
        public bool IsArticleCommentHidden { get; set; }
        [ResultColumn]
        public string AboutMe { get; set; }
        [ResultColumn]
        public bool IsPublicMsgHidden { get; set; }
        [ResultColumn]
        public string Profession { get; set; }

        public PPUserEntity()
        {
            UserRoles = new List<UserRoleEntity>();
        }
    }
    public class UserRoleRightsEntity : RoleRight
    {
        [ResultColumn]
        public string EntityName { get; set; }
    }
    public class UserRoleEntity
    {
        public Guid UserID { get; set; }
        public string RoleName { get; set; }
    }

    public class UserForgotPassword
    {
        public int UserID { get; set; }
        public string VerificationCode { get; set; }
    }

    public class DashboardStatisticEntity
    {
        public int NumberOfCompanies { get; set; }
        public int NumberOfCustomers { get; set; }
        public int NumberOfAds { get; set; }
        public int NumberOfVariants { get; set; }
    }
    public class DashboardSummary
    {
        public string CountNo { get; set; }
        public string ColumnName { get; set; }
    }
}