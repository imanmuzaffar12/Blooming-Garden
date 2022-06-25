using Newtonsoft.Json;
using Framework.Application.Services;
using Framework.Web.CommonCode.Helpers;
using Framework.Web.Models;
using Framework.Shared.DataServices;
using Framework.Shared.DataServices.CustomEntities;
using Framework.Shared.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Threading.Tasks;
using Adoofy.CommonCode;

namespace Framework.Web.CommonCode
{
    public abstract class DynamicExtender
    {
        public virtual bool IsValidToSave(object obj) { return false; }
        public virtual string ValidationMessage(object obj) { return string.Empty; }
        public virtual void BeforeSave(object obj, FormCollection formValues) { }
        public virtual void BeforeUpdate(object obj, FormCollection formValues, object id) { }
        public virtual void AfterSave(object obj, FormCollection formValues) { }
        public virtual void AfterUpdate(object obj, FormCollection formValues, object id) { }
        public virtual void BeforeDelete(object obj, FormCollection formValues, object id, string configs) { }
        public virtual void AfterDelete(object obj, FormCollection formValues) { }

    }
    public class EntitiesExtender : DynamicExtender
    {
        public override bool IsValidToSave(object obj) { return true; }
        public override string ValidationMessage(object obj) { return string.Empty; }
        public override void AfterSave(object obj, FormCollection formValues)
        {
            short entityID = (short)obj;
            string tableName = formValues["EntityName"];
            using (var context = DataContextHelper.GetCPDataContext())
            {
                string query = string.Format(@"
                                    Insert Into EntityDetails (EntityID, ColumnName, DisplayNameEn, DisplayNameAr, DbTypeID, IsRequired, IsGroup, IsForeignkey, RefrencedTableName, EnableAutoComplate,  AddEditVisible, GridVisible, SearchFilterVisible, MaxLength, IsAutoID, IsPrimaryKey, DisplaySeqNo, IsFileUpload, ShowGroupTitle)
                                    Select
                                    {0} As  EntityID,
                                    c.name As ColumnName, 
                                    c.name As DisplayNameEn, 
                                    c.name As DisplayNameAr, 
                                    c.system_type_id As DbTypeID,
                                    ~c.is_nullable As IsRequired,
                                    0 As IsGroup,
                                    IsNull((select top 1 1 from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id), 0) As IsForeignkey,
                                    (select name from sys.objects Where object_id = (select f.referenced_object_id from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id)) RefrencedTableName,
                                    0 As EnableAutoComplate,
                                    0 As AddEditVisible, 
                                    0 As GridVisible,
                                    0 As SearchFilterVisible, 
                                    c.max_length As MaxLength, 
                                    c.is_identity As IsAutoID,
                                    IsNull((select 1 from sys.indexes i inner join sys.index_columns ic on i.object_id = ic.object_id and  i.index_id = ic.index_id Where i.object_id =  c.object_id and i.is_primary_key = 1 and ic.column_id = c.column_id),0) As IsPrimaryKey,
                                    0 As DisplaySeqNo, 0 As IsFileUpload, 
                                    0 As ShowGroupTitle
                                    From Sys.columns c
                                    Where c.object_id = OBJECT_ID('{1}')
                                    And c.name Not In (Select ColumnName From EntityDetails Where EntityID = {0})", entityID, tableName);
                context.Execute(query);
                context.Execute("Update EntityDetails Set IsAutoID = 1 Where ColumnName IN ('CreatedOn', 'CreatedBy', 'ModifiedOn', 'ModifiedBy') AND EntityID = @0", entityID);
            }
        }
        public override void BeforeDelete(object obj, FormCollection formValues, object id, string configs)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                context.Execute("Delete From RoleRights Where EntityID = @0", id);
                context.Execute("Delete From EntityDetails Where EntityID = @0", id);
            }
        }
    }
    public class DynamicSetupScreenExtender : DynamicExtender
    {
        public override bool IsValidToSave(object obj) { return true; }
        public override string ValidationMessage(object obj) { return string.Empty; }
        public override void BeforeSave(object obj, FormCollection formValues) { }
        public override void BeforeUpdate(object obj, FormCollection formValues, object id)
        {


        }
        public override void AfterSave(object obj, FormCollection formValues)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                string entityName = formValues["DS_TableName"];

                Entity entity = new Entity();
                entity.EntityName = entityName;
                entity.IsActive = true;
                context.Insert(entity);
                int entityID = entity.EntityID;

                string query = string.Format(@"
                                    Insert Into EntityDetails (EntityID, ColumnName, DisplayNameEn, DisplayNameAr, DbTypeID, IsRequired, IsGroup, IsForeignkey, RefrencedTableName, EnableAutoComplate,  AddEditVisible, GridVisible, SearchFilterVisible, MaxLength, IsAutoID, IsPrimaryKey, DisplaySeqNo, IsFileUpload, ShowGroupTitle)
                                    Select
                                    {0} As  EntityID,
                                    c.name As ColumnName, 
                                    c.name As DisplayNameEn, 
                                    c.name As DisplayNameAr, 
                                    c.system_type_id As DbTypeID,
                                    ~c.is_nullable As IsRequired,
                                    0 As IsGroup,
                                    IsNull((select top 1 1 from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id), 0) As IsForeignkey,
                                    (select name from sys.objects Where object_id = (select f.referenced_object_id from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id)) RefrencedTableName,
                                    0 As EnableAutoComplate,
                                    0 As AddEditVisible, 
                                    0 As GridVisible,
                                    0 As SearchFilterVisible, 
                                    c.max_length As MaxLength, 
                                    c.is_identity As IsAutoID,
                                    IsNull((select 1 from sys.indexes i inner join sys.index_columns ic on i.object_id = ic.object_id and  i.index_id = ic.index_id Where i.object_id =  c.object_id and i.is_primary_key = 1 and ic.column_id = c.column_id),0) As IsPrimaryKey,
                                    0 As DisplaySeqNo, 0 As IsFileUpload, 
                                    0 As ShowGroupTitle
                                    From Sys.columns c
                                    Where c.object_id = OBJECT_ID('{1}')
                                    And c.name Not In (Select ColumnName From EntityDetails Where EntityID = {0})", entityID, entityName);
                context.Execute(query);
                context.Execute("Update EntityDetails Set IsAutoID = 1 Where ColumnName IN ('CreatedOn', 'CreatedBy', 'ModifiedOn', 'ModifiedBy') AND EntityID = @0", entityID);

                //query = string.Format(@"INSERT INTO MenuNavigations (MenuNavigationName, EntityID, ParentMenuNavigationID, DisplaySeqNo, LinkUrl, IconClass, IsActive, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) 
                //                        OUTPUT INSERTED.MenuNavigationID
                //                        VALUES ('Manage {0}', {1}, NULL, (SELECT MAX(DisplaySeqNo) + 1 FROM MenuNavigations), NULL, '', 1, '{2}', {3}, '{2}', {3})", entityName, entityID, DateTime.Now, Authentication.Instance.User.UserID);

                //int menuNavigationID = context.ExecuteScalar<int>(query, null);
                query = string.Format(@"INSERT INTO RoleRights (RoleID, RightID, EntityID, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy)
                                        SELECT (SELECT TOP 1 RoleID FROM Roles WHERE RoleName = 'Admin') RoleID, RightID, {0} EntityID, '{1}' CreatedOn, {2} CreatedBy, '{1}' ModifiedOn, {2} ModifiedBy FROM Rights", entityID, DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"), Authentication.Instance.User.UserID);
                int rolesRightID = context.Execute(query);

            }
        }
        public override void AfterUpdate(object obj, FormCollection formValues, object id)
        {

        }
        public override void BeforeDelete(object obj, FormCollection formValues, object id, string configs)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                int entityID = context.Execute("Select EntityID From Entities Where EntityName = @0", formValues["DS_TableName"]);
                context.Execute("Delete From RoleRights Where EntityID = @0", entityID);
                context.Execute("Delete From EntityDetails Where EntityID = @0", entityID);
            }
        }
        public override void AfterDelete(object obj, FormCollection formValues) { }
    }
    public class UserExtender : DynamicExtender
    {
        public override bool IsValidToSave(object obj) { return true; }

        public override void AfterSave(object obj, FormCollection formValues)
        {
            string emailAddress = formValues["EmailAddress"];
            string fullName = formValues["FullName"];
            string password = formValues["Password"].Encrypt();
            Task.Run(() => BroadcastHelper.SendEmailAsync(fullName, "Welcome to Blooming Garden", emailAddress, password, "", string.Empty, string.Empty, string.Empty, "Registration")); ;
        }
        public override void BeforeDelete(object obj, FormCollection formValues, object id, string configs)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                context.Execute("Delete From UserRoles where userid = @0", id);
            }
        }
    }
}