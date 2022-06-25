using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Framework.Shared.DataServices;

namespace Framework.Application.Services
{
    public class AuthenticationServices
    {
        #region Define as Singleton
        private static AuthenticationServices _Instance;

        public static AuthenticationServices Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new AuthenticationServices();
                }

                return (_Instance);
            }
        }

        private AuthenticationServices()
        {
        }
        #endregion
        public UserEntity LoginUser(string emailAddress, string password)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, 2 As RecordStatusInt")
                            .From("Users")
                            .Where("EmailAddress = @0", emailAddress)
                            .Where("Password = @0", password);
                return context.Fetch<UserEntity>(ppSql).FirstOrDefault();
            }
        }
        public UserEntity LoginUser(string emailAddres)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, 2 As RecordStatusInt")
                            .From("Users")
                            .Where("Email = @0", emailAddres);

                return context.Fetch<UserEntity>(ppSql).FirstOrDefault();
            }
        }
        public UserEntity LoginUser(int userID, string md5Hash)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*, 2 As RecordStatusInt")
                            .From("Users")
                            .Where("UserID = @0", userID);

                var user = context.Fetch<UserEntity>(ppSql).FirstOrDefault();
                if (user.MD5Hash == md5Hash)
                {
                    return user;
                }
                return null;
            }
        }
        public List<UserRoleRightsEntity> GetUserRoleRights(int userID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder.Select("RoleID").From("UserRoles").Where("UserID = @0", userID);
                short roleID = context.Fetch<short>(sql).FirstOrDefault();
                var cpSql = PetaPoco.Sql.Builder.Select("UR.RoleID, UR.RightID, UR.EntityID, E.EntityName EntityName").From("RoleRights UR").InnerJoin("Entities E").On("E.EntityID = UR.EntityID").Where("UR.RoleID = @0", roleID);
                return context.Fetch<UserRoleRightsEntity>(cpSql);
            }
        }
    }
}
