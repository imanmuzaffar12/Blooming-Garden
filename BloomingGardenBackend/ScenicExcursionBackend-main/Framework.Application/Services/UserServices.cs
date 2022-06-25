using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Framework.Shared.DataServices;
using Basketo.Shared;
using System.Reflection;
namespace Framework.Application.Services
{
    public class UserServices
    {
        #region Define as Singleton
        private static UserServices _Instance;

        public static UserServices Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new UserServices();
                }

                return (_Instance);
            }
        }

        private UserServices()
        {
        }
        #endregion

        public List<UserEntity> GetPublicPortalUsers(int pageNo, int pageSize, bool allUser = false)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, TotalRecords = Count(*) Over()")
                            .From("Users")
                            .Where("IsCPUser = 0 ")
                            .OrderBy("UserID Desc");
                if (!allUser)
                {
                    ppSql = ppSql.Paginate(pageNo, pageSize);
                }

                return context.Fetch<UserEntity>(ppSql);
            }
        }
        public List<UserEntity> SearchPublicPortalUsers(string text, int? statusid, int pageNo, int pageSize)
        {
            text = string.IsNullOrEmpty(text) ? string.Empty : string.Format("%{0}%", text);
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, TotalRecords = Count(*) Over()")
                            .From("Users")
                            .Where("IsCPUser = 0 ");
                if (statusid.HasValue)
                {
                    ppSql.Where("RecordStatus = @0", statusid.Value);
                }
                if (!string.IsNullOrEmpty(text))
                {
                    ppSql.Where("Email Like @0 Or FirstName Like @0 Or LastName Like @0 Or DisplayName Like @0", text);
                }
                ppSql.OrderBy("UserID Desc")
                .Paginate(pageNo, pageSize);


                return context.Fetch<UserEntity>(ppSql);
            }
        }
        public List<UserEntity> GetControlPanelUsers(int pageNo, int pageSize)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, TotalRecords = Count(*) Over()")
                            .From("Users")
                            .Where("IsCPUser = 1 ")
                            .OrderBy("UserID Desc")
                            .Paginate(pageNo, pageSize);


                return context.Fetch<UserEntity>(ppSql);
            }
        }
        public List<UserEntity> SearchControlPanelUsers(string text, int? statusid, int pageNo, int pageSize)
        {
            text = string.IsNullOrEmpty(text) ? string.Empty : string.Format("%{0}%", text);
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, TotalRecords = Count(*) Over()")
                            .From("Users")
                            .Where("IsCPUser = 1 ");
                if (statusid.HasValue)
                {
                    ppSql.Where("RecordStatus = @0", statusid.Value);
                }
                if (!string.IsNullOrEmpty(text))
                {
                    ppSql.Where("Email Like @0 Or FirstName Like @0 Or LastName Like @0 Or DisplayName Like @0", text);
                }
                ppSql.OrderBy("UserID Desc")
                .Paginate(pageNo, pageSize);


                return context.Fetch<UserEntity>(ppSql);
            }
        }
        public int AddUser(User user)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                context.Insert(user);
                return user.UserID;
            }
        }
        public void UpdateUser(User user,int logInID=0)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var dbUser = context.Fetch<User>("Select * From Users Where UserID = @0", user.UserID).FirstOrDefault();
                CommonCode commonCode = new CommonCode();
                user.Password = dbUser.Password;
                context.Update(user);
            }
        }
        public void UpdateUserProfile(User user)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var dbUser = context.Fetch<User>("Select * From Users Where UserID = @0", user.UserID).FirstOrDefault();
                if (string.IsNullOrEmpty(user.Password))
                {
                    user.Password = dbUser.Password; //Keep the Old
                }
                else
                {
                    user.Password = user.Password.Encrypt(); //Change it
                }
                context.Update(user);
            }
        }
        //public void AssignedRolesToUser(int userId, short[] roles)
        //{
        //    using (var context = DataContextHelper.GetCPDataContext())
        //    {
        //        context.Execute("Delete From UserCPRoles Where UserID = @0", userId);
        //        foreach (short r in roles)
        //        {
        //            if (r == 0)
        //                continue;
        //            UserCPRole u = new UserCPRole();
        //            u.UserID = userId;
        //            u.CPRoleID = r;
        //            context.Insert(u);
        //        }
        //    }
        //}
        //public List<CPRole> GetUserRoles(int userID)
        //{
        //    using (var context = DataContextHelper.GetCPDataContext())
        //    {
        //        var ppSql = PetaPoco.Sql.Builder.Select(@"R.*")
        //                    .From("CPRoles R")
        //                    .InnerJoin("UserCPRoles U").On("R.CPRoleID = U.CPRoleID")
        //                    .Where("U.UserID = @0", userID);

        //        return context.Fetch<CPRole>(ppSql);
        //    }
        //}
        public UserEntity GetUserByID(int userId)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*")
                            .From("Users")
                            .Where("UserID = @0", userId);

                return context.Fetch<UserEntity>(ppSql).FirstOrDefault();
            }
        }
        public UserEntity GetUserByEmail(string emailAddress)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*")
                            .From("Users")
                            .Where("Email = @0", emailAddress);

                return context.Fetch<UserEntity>(ppSql).FirstOrDefault();
            }
        }
        //public List<CPRole> GetAllRoles()
        //{
        //    using (var context = DataContextHelper.GetCPDataContext())
        //    {
        //        var ppSql = PetaPoco.Sql.Builder.Select(@"*")
        //                    .From("CPRoles");

        //        return context.Fetch<CPRole>(ppSql);
        //    }
        //}
        public List<User> GetAllCPUsers()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*")
                            .From("Users")
                            .Where("IsCPUser = 1")
                            .OrderBy("DisplayName");

                return context.Fetch<User>(ppSql).ToList();
            }
        }
        public bool IsUserIDExist(int userID)
        {
            User users = null;
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder.Select("*").From("Users")
                .Where("UserID = @0", userID);
                users = context.SingleOrDefault<User>(sql);
            }
            return users != null ? true : false;
        }
    }
}
