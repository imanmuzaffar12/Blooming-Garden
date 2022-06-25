using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Basketo.Shared;
using Framework.Shared.DataServices;
using Framework.Shared.Enums;
using Framework.Shared.Helpers;
using Framework.Shared.DataServices.CustomEntities;
using System.Reflection;
using System.Globalization;
using System.Text.RegularExpressions;
using ServiceStack.Text;

namespace Framework.Application.Services
{
    public class CommonServices
    {
        #region Define as Singleton
        private static CommonServices _Instance;

        public static CommonServices Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new CommonServices();
                }

                return (_Instance);
            }
        }

        private CommonServices()
        {
        }
        #endregion

        public List<EntityDetail> GetAllEntityDetails(int entityID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var query = PetaPoco.Sql.Builder.Select("*")
                        .From("EntityDetails")
                        .Where("EntityID = @0", entityID);
                return context.Fetch<EntityDetail>(query).ToList();
            }
        }

        #region Private Method
        #endregion

        public DynamicPage GetTablePage(string tableName)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                DynamicPage page = new DynamicPage();
                page.TableName = tableName;
                page.PageTitle = tableName.Wordify();
                page.Fields = context.Fetch<DynamicField>("Select * From EntityDetails Where EntityID = (Select EntityID From Entities Where EntityName = @0)", tableName).ToList();
                if (page.Fields != null && page.Fields.Count != 0)
                {
                    page.EntityID = page.Fields.FirstOrDefault().EntityID;
                }
                else
                {
                    var query = PetaPoco.Sql.Builder.Select("c.name As Name, ~c.is_nullable As IsRequired,(c.max_length/(IsNull((Select 2 Where c.system_type_id = 231),1))) As MaxLength, c.system_type_id As DbTypeID,c.is_identity As IsAutoID,IsNull((select top 1 1 from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id), 0) As IsForeignkey,(select name from sys.objects Where object_id = (select top 1 f.referenced_object_id from sys.foreign_key_columns f where f.parent_column_id = c.column_id AND f.parent_object_id = c.object_id)) RefrencedTableName,(select 1 from sys.indexes i inner join sys.index_columns ic on i.object_id = ic.object_id and  i.index_id = ic.index_id Where i.object_id =  c.object_id and i.is_primary_key = 1 and ic.column_id = c.column_id) As IsPrimaryKey");
                    query.From("sys.columns c")
                        .InnerJoin("sysobjects o").On("c.object_id = o.id")
                        .Where("o.name = @0", tableName);

                    page.Fields = context.Fetch<DynamicField>(query).ToList();
                }
                //if (tableName.ToLower() == "companyshares")
                //{
                //    DynamicField dynFld = page.Fields.Where(f => f.Name == "CreatedOn").FirstOrDefault();
                //    if (dynFld != null)
                //    {
                //        dynFld.MaxLength = 10;
                //    }
                //}

                return page;
            }
        }
        public List<Dictionary<string, object>> GetTableListingData(string tableName, List<string> fieldNames, Dictionary<string, object> searchFields, string searchTerm, List<string> searchTermFields, int pageNo, int pageSize, bool allowPaging, string customCondition)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var query = PetaPoco.Sql.Builder.Select(string.Join(",", fieldNames));
                query.From(tableName);
                if (searchFields != null)
                {
                    foreach (var sf in searchFields)
                    {
                        if (sf.Value.ToString().Contains(","))
                        {
                            query.Where(sf.Key + " IN(@0)", sf.Value.ToString().Split(",".ToArray()).Select(x => int.Parse(x)).ToList());
                        }
                        else
                        {
                            query.Where(sf.Key + " = @0", sf.Value);
                        }
                    }
                }
                if (searchTermFields != null && !string.IsNullOrEmpty(searchTerm))
                {
                    string str = "";
                    foreach (string sft in searchTermFields)
                    {
                        if (!string.IsNullOrEmpty(str))
                        {
                            str = str + " OR ";
                        }
                        str = string.Format("{0} {1} Like @0 ", str, sft);
                    }
                    searchTerm = string.Format("%{0}%", searchTerm);
                    if (!string.IsNullOrEmpty(str))
                    {
                        query.Where(str, searchTerm);
                    }
                }
                if (!string.IsNullOrEmpty(customCondition))
                {
                    query.Where(customCondition);
                }
                query.OrderBy(fieldNames[0] + " Desc");
                if (allowPaging)
                {
                    query.Paginate(pageNo, pageSize);
                }
                var list = context.Fetch<dynamic>(query).ToList();
                List<Dictionary<string, object>> finalList = new List<Dictionary<string, object>>();

                foreach (var row in list)
                {
                    Dictionary<string, object> dic = new Dictionary<string, object>();
                    foreach (var t in row)
                    {
                        dic.Add(t.Key, t.Value);
                    }
                    finalList.Add(dic);
                }

                return finalList;
            }
        }
        public List<Dictionary<string, object>> GetTableListingData(string tableName, List<string> fieldNames, Dictionary<string, object> searchFields, string searchTerm, List<string> searchTermFields, string customCondition, int pageNo, int pageSize, bool allowPaging)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var query = PetaPoco.Sql.Builder.Select(string.Join(",", fieldNames));
                query.From(tableName);
                if (searchFields != null)
                {
                    foreach (var sf in searchFields)
                    {
                        if (sf.Value.ToString().Contains(","))
                        {
                            query.Where(sf.Key + " IN(@0)", sf.Value.ToString().Split(",".ToArray()).Select(x => int.Parse(x)).ToList());
                        }
                        else
                        {
                            query.Where(sf.Key + " = @0", sf.Value);
                        }
                    }
                }
                if (searchTermFields != null && !string.IsNullOrEmpty(searchTerm))
                {
                    string str = "";
                    foreach (string sft in searchTermFields)
                    {
                        if (!string.IsNullOrEmpty(str))
                        {
                            str = str + " OR ";
                        }
                        str = string.Format("{0} {1} Like @0 ", str, sft);
                    }
                    searchTerm = string.Format("%{0}%", searchTerm);
                    if (!string.IsNullOrEmpty(str))
                    {
                        query.Where(str, searchTerm);
                    }
                }
                if (!string.IsNullOrEmpty(customCondition))
                {
                    query.Where(customCondition);
                }
                query.OrderBy(fieldNames[0] + " Desc");
                if (allowPaging)
                {
                    query.Paginate(pageNo, pageSize);
                }
                var list = context.Fetch<dynamic>(query).ToList();
                List<Dictionary<string, object>> finalList = new List<Dictionary<string, object>>();

                foreach (var row in list)
                {
                    Dictionary<string, object> dic = new Dictionary<string, object>();
                    foreach (var t in row)
                    {
                        dic.Add(t.Key, t.Value);
                    }
                    finalList.Add(dic);
                }

                return finalList;
            }
        }
        public List<Dictionary<string, object>> GetTableListingData(string tableName, List<string> fieldNames, Dictionary<string, object> searchFields, string searchTerm, List<string> searchTermFields, int pageNo, int pageSize, bool allowPaging, string parentField = null, string customCondition = null)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var query = PetaPoco.Sql.Builder.Select(string.Join(",", fieldNames));
                query.From(tableName);
                if (searchFields != null)
                {
                    foreach (var sf in searchFields)
                    {
                        query.Where(sf.Key + " = @0", sf.Value);
                    }
                }
                if (searchTermFields != null)
                {
                    string str = "";
                    foreach (string sft in searchTermFields)
                    {
                        if (!string.IsNullOrEmpty(str))
                        {
                            str = str + " OR ";
                        }
                        str = string.Format("{0} {1} Like @0 ", str, sft);
                    }
                    searchTerm = string.Format("%{0}%", searchTerm);
                    query.Where(str, searchTerm);
                }
                if (!string.IsNullOrEmpty(parentField))
                {
                    query.Where(string.Format("{0} Is Null", parentField));
                }
                if (!string.IsNullOrEmpty(customCondition))
                {
                    query.Where(customCondition);
                }
                query.OrderBy(fieldNames[0]);
                if (allowPaging)
                {
                    query.Paginate(pageNo, pageSize);
                }
                var list = context.Fetch<dynamic>(query).ToList();
                List<Dictionary<string, object>> finalList = new List<Dictionary<string, object>>();

                foreach (var row in list)
                {
                    Dictionary<string, object> dic = new Dictionary<string, object>();
                    foreach (var t in row)
                    {
                        dic.Add(t.Key, t.Value);
                    }
                    finalList.Add(dic);
                }

                return finalList;
            }
        }
        public List<Dictionary<string, object>> GetTableListingData(string tableName, List<string> fieldNames, Dictionary<string, object> searchFields, string searchTerm, List<string> searchTermFields, int pageNo, int pageSize, bool allowPaging, string parentField = null, string customCondition = null, string orderBy = null, string dateFilters = null, string fromDate = null, string toDate = null, string customQuery = null, bool viewSelf = true, int userID = 0, int businessID = 0)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var query = PetaPoco.Sql.Builder;
                if (!string.IsNullOrEmpty(customQuery))
                {
                    query = query.Append(customQuery);
                }
                else
                {
                    query = query.Select(string.Join(",", fieldNames));
                    query.From(tableName);
                }
                if (searchFields != null)
                {
                    foreach (var sf in searchFields)
                    {
                        query.Where(sf.Key + " = @0", sf.Value);
                    }
                }
                if (searchTermFields != null && searchTermFields.Count != 0 && !string.IsNullOrEmpty(searchTerm))
                {
                    string str = "";
                    foreach (string sft in searchTermFields)
                    {
                        if (!string.IsNullOrEmpty(str))
                        {
                            str = str + " OR ";
                        }
                        str = string.Format("{0} {1} Like @0 ", str, sft);
                    }
                    searchTerm = string.Format("%{0}%", searchTerm);
                    query.Where(str, searchTerm);
                }
                if (!string.IsNullOrEmpty(parentField))
                {
                    query.Where(string.Format("{0} Is Null", parentField));
                }
                if (!string.IsNullOrEmpty(customCondition))
                {
                    query.Where(customCondition);
                }
                if (viewSelf)
                {
                    if (tableName == "UserEarnedPoints" || tableName == "UserConsumedPoints")
                    {
                        query.Where("BusinessID = @0", businessID);
                    }
                    else
                    {
                        query.Where("CreatedBy = @0", userID);
                    }
                }
                if (!string.IsNullOrEmpty(fromDate) && !string.IsNullOrEmpty(toDate))
                {
                    if (!string.IsNullOrEmpty(dateFilters))
                    {
                        foreach (var filter in dateFilters.Split(','))
                        {
                            query.Where(filter + " BETWEEN @0 AND @1", fromDate, toDate);
                        }
                    }
                }
                if (!string.IsNullOrEmpty(orderBy))
                {
                    query.OrderBy(orderBy);
                }
                else
                {
                    query.OrderBy(fieldNames[0]);
                }
                if (allowPaging)
                {
                    query.Paginate(pageNo, pageSize);
                }
                var list = context.Fetch<dynamic>(query).ToList();
                List<Dictionary<string, object>> finalList = new List<Dictionary<string, object>>();

                foreach (var row in list)
                {
                    Dictionary<string, object> dic = new Dictionary<string, object>();
                    foreach (var t in row)
                    {
                        dic.Add(t.Key, t.Value);
                    }
                    finalList.Add(dic);
                }

                return finalList;
            }
        }
        public List<Dictionary<string, object>> GetTableListingData(string tableName, string columns, string joiningTables, string whereCondition)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder.Select(columns).From(tableName).Append(joiningTables);
                if (!string.IsNullOrEmpty(whereCondition))
                {
                    sql = sql.Where(whereCondition);
                }

                var list = context.Fetch<dynamic>(sql);
                List<Dictionary<string, object>> finalList = new List<Dictionary<string, object>>();

                foreach (var row in list)
                {
                    Dictionary<string, object> dic = new Dictionary<string, object>();
                    foreach (var t in row)
                    {
                        dic.Add(t.Key, t.Value);
                    }
                    finalList.Add(dic);
                }
                return finalList;
            }
        }
        public object ToPocoObject(string tableName, List<DynamicField> fields, Dictionary<string, object> fieldValues)
        {

            var tbPoco = Activator.CreateInstance("Framework.Shared", string.Format("Framework.Shared.DataServices.{0}", tableName.Singlofy()));
            var poco = tbPoco.Unwrap();
            string pkColumn = fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
            // poco = context.Fetch<dynamic>("Select * From " + tableName + " Where " + pkColumn + " = @0", fieldValues[pkColumn]).FirstOrDefault(); 
            foreach (var f in fields)
            {
                if (!fieldValues.ContainsKey(f.Name) || string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                {
                    continue;
                }
                if (f.IsBoolean)
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, bool.Parse(fieldValues[f.Name].ToString()));
                }
                else if (f.IsInt16 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, Int16.Parse(fieldValues[f.Name].ToString()));
                }
                else if (f.IsInt32 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, Int32.Parse(fieldValues[f.Name].ToString()));
                }
                else if (f.IsDecimal)
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, Decimal.Parse(fieldValues[f.Name].ToString()));
                }
                else if (f.IsDateTime)
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, DateTime.Parse(fieldValues[f.Name].ToString()));
                }
                else if (!string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                {
                    poco.GetType().GetProperty(f.Name).SetValue(poco, fieldValues[f.Name]);
                }

            }
            return poco;
        }
        public Dictionary<string, object> GetTableSingleRecord(string tableName, List<string> fieldNames, Dictionary<string, object> searchFields)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                // var tbPoco = Activator.CreateInstance("Framework.Shared", string.Format("Framework.Shared.DataServices.{0}", tableName.Singlofy()));
                var query = PetaPoco.Sql.Builder.Select(string.Join(",", fieldNames));
                query.From(tableName);
                foreach (var sf in searchFields)
                {
                    query.Where(sf.Key + " = @0", sf.Value);
                }
                //Tuple.Create(tbPoco.Unwrap())
                var row = context.Fetch<dynamic>(query).FirstOrDefault();
                Dictionary<string, object> record = new Dictionary<string, object>();
                if (row == null)
                {
                    return null;
                }
                foreach (var t in row)
                {
                    record.Add(t.Key, t.Value);
                }


                return record;
            }
        }
        public object SaveTableRecord(string tableName, List<DynamicField> fields, Dictionary<string, object> fieldValues)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var tbPoco = Activator.CreateInstance("Framework.Shared", string.Format("Framework.Shared.DataServices.{0}", tableName.Singlofy()));
                var poco = tbPoco.Unwrap();
                string pkName = fields.Where(x => x.IsPrimaryKey).Select(x => x.ColumnName).FirstOrDefault();
                bool hasAutoID = false;
                foreach (var f in fields.Where(x => !(x.IsGroup.HasValue && x.IsGroup.Value)).ToList())
                {

                    if (f.IsAutoID && !f.IsDateTime && f.Name != "CreatedBy")
                    {
                        hasAutoID = true;
                        continue;
                    }
                    if (poco.GetType().GetProperty(f.Name) == null)
                    {
                        continue;
                    }
                    if (!fieldValues.ContainsKey(f.Name))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, null);
                        continue;
                    }
                    if (f.IsBoolean)
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, bool.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsInt16 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, Int16.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsInt32 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, Int32.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsDateTime && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, DateTime.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (!string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        if (poco.GetType().GetProperty(f.Name).PropertyType.GetCoreType().Name.ToLower().Contains("decimal"))
                        {
                            poco.GetType().GetProperty(f.Name).SetValue(poco, decimal.Parse(fieldValues[f.Name].ToString().Trim()));
                        }
                        else
                        {
                            poco.GetType().GetProperty(f.Name).SetValue(poco, fieldValues[f.Name].ToString().Trim());
                        }
                    }
                }
                poco = context.Insert(poco);// tableName,pkName,hasAutoID,true, poco);
                return poco;
            }
        }
        public void UpdateTableDisplayOrders(string tableName, string displayFieldName, string pkColumName, string OrderdPkValues)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                int index = 1;
                foreach (string value in OrderdPkValues.Split(",".ToCharArray()))
                {
                    string commond = string.Format("Update {0} Set {1} = {2} Where {3} = {4}", tableName, displayFieldName, index, pkColumName, value);
                    context.Execute(commond);
                    index++;
                }
            }
        }
        public void ResetTableDisplayOrders(string tableName, string displayFieldName)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                string commond = string.Format("Update {0} Set {1} = {2}", tableName, displayFieldName, 0);
                context.Execute(commond);
            }
        }
        public object UpdateTableRecord(string tableName, List<DynamicField> fields, Dictionary<string, object> fieldValues)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var tbPoco = Activator.CreateInstance("Framework.Shared", string.Format("Framework.Shared.DataServices.{0}", tableName.Singlofy()));
                var poco = tbPoco.Unwrap();
                string pkColumn = fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                // poco = context.Fetch<dynamic>("Select * From " + tableName + " Where " + pkColumn + " = @0", fieldValues[pkColumn]).FirstOrDefault(); 
                var id = fieldValues[pkColumn];
                foreach (var f in fields)
                {
                    if (!fieldValues.ContainsKey(f.Name) || string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        continue;
                    }
                    if (poco.GetType().GetProperty(f.Name) == null)
                    {
                        continue;
                    }
                    if (f.IsBoolean)
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, bool.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsInt16 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, Int16.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsInt32 && !string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, Int32.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsDecimal)
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, Decimal.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (f.IsDateTime)
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, DateTime.Parse(fieldValues[f.Name].ToString()));
                    }
                    else if (!string.IsNullOrEmpty(fieldValues[f.Name].ToString()))
                    {
                        poco.GetType().GetProperty(f.Name).SetValue(poco, fieldValues[f.Name]);
                    }

                }
                context.Update(poco);
                return id;
            }
        }
        public void DeleteTableRecord(string tableName, string pkColumn, object id)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                //TODO: Soft Delete Check kerain 
                context.Execute(string.Format("Delete From {0} Where {1} = @0", tableName, pkColumn), id);
            }
        }
        public object GetTableRecordForDelete(string tableName, string pkColumn, object id)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                //TODO: 
                return context.Fetch<object>(string.Format("select * From {0} Where {1} = @0", tableName, pkColumn), id).FirstOrDefault();
            }
        }
        public DynamicEntity GetEntity(int entityID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                return context.Fetch<DynamicEntity>("Select * From Entities Where EntityID = @0", entityID).FirstOrDefault();
            }
        }
        public List<DynamicEntityRow> GetEntityRows(string entityName, string displayField, string valueField)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                string sql = string.Format("Select Top 10000 {0} As FieldNameEn, {1} As FieldID From {2} Order By {1} Desc", displayField, valueField, entityName);
                return context.Fetch<DynamicEntityRow>(sql).ToList();
            }
        }
        public List<DynamicEntityRow> GetEntityRowsHasAttributes(int entityID, string entityName, string displayField, string valueField)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Select(string.Format("Distinct {0} As FieldNameEn, {1} As FieldID ", displayField, valueField))
                    .From(string.Format("{0}  A", entityName))
                    .InnerJoin("EntityAttributes EA").On(string.Format("A.{0} = EA.RowID And EA.EntityID = {1}", valueField, entityID));

                //string sql = string.Format("Select Top 10000 {0} As FieldNameEn, {1} As FieldID From {2} Order By {1} Desc", displayField, valueField, entityName);
                return context.Fetch<DynamicEntityRow>(sql).ToList();
            }
        }
        public List<DynamicEntityRow> GetEntityRows(int entityID, string entityName, string displayField, string valueField)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Select(string.Format("Distinct {0} As FieldNameEn, {1} As FieldID ", displayField, valueField))
                    .From(string.Format("{0}  A", entityName));

                //string sql = string.Format("Select Top 10000 {0} As FieldNameEn, {1} As FieldID From {2} Order By {1} Desc", displayField, valueField, entityName);
                return context.Fetch<DynamicEntityRow>(sql).ToList();
            }
        }
        public List<DynamicEntityAttributEntity> GetEntityAttributes(string entityName, int entityID, string displayField, string valueField)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Select(string.Format("A.*, B.{0} As FieldNameEn,EA.RowID As FieldID", displayField))
                    .From("EntityAttributes EA")
                    .InnerJoin(string.Format("{0} B", entityName)).On(string.Format("B.{0} = EA.RowID", valueField))
                    .InnerJoin("Attributes A").On("A.AttributeID = EA.AttributeID")
                    .Where("EA.EntityID = @0", entityID)
                    .Where("EA.IsDeleted = 0")
                    .OrderBy("EA.DisplaySeqNo Asc");
                return context.Fetch<DynamicEntityAttributEntity>(sql).ToList();
            }
        }
        public string GetAPI(string name, Dictionary<string, object> param)
        {
            var apiConfiguration = GetAPIConfiguration(name);
            if (apiConfiguration != null)
            {
                return GetData(name, apiConfiguration, param);
            }
            return "[]";
        }
        public string GetData(string apiName, APIConfiguration apiConfiguration, Dictionary<string, object> param)
        {
            return ServiceExecutionHelper.Instance.GetDataAsync(() =>
            {
                using (var context = DataContextHelper.GetCPDataContext())
                {
                    if (apiConfiguration != null)
                    {
                        if (apiConfiguration.SqlQuery.ToLower().Contains("insert") || apiConfiguration.SqlQuery.ToLower().Contains("update"))
                        {
                            try
                            {
                                context.Execute(apiConfiguration.SqlQuery, param);
                                return "[{'Status':'Success'}]";
                            }
                            catch (Exception ex)
                            {
                                return string.Format("[{'Status':'{0}'}]", ex.Message);
                            }
                        }
                    }
                    return context.Fetch<string>(apiConfiguration.SqlQuery, param).FirstOrDefault();
                }
            }, apiName: apiName, isCacheAllowed: (bool)apiConfiguration.IsCacheAllowed);
        }
        public APIConfiguration GetAPIConfiguration(string name)
        {
            return ServiceExecutionHelper.Instance.GetDataAsync(() =>
            {
                using (var context = DataContextHelper.GetCPDataContext())
                {
                    return context.Fetch<APIConfiguration>("Select * From APIConfigurations Where UrlName = @0", name).FirstOrDefault();
                }
            });
        }
        public string PostAPI(string name, Dictionary<string, object> param)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var apiConfiguration = context.Fetch<APIConfiguration>("Select * From APIConfigurations Where UrlName = @0", name).FirstOrDefault();
                if (apiConfiguration != null)
                {
                    if (apiConfiguration.SqlQuery.ToLower().Contains("insert") || apiConfiguration.SqlQuery.ToLower().Contains("update"))
                    {
                        try
                        {
                            return context.Fetch<string>(";" + apiConfiguration.SqlQuery, param).FirstOrDefault();
                        }
                        catch (Exception ex)
                        {
                            return string.Format("{0}", ex.Message);
                        }
                    }
                }
                return context.Fetch<string>(apiConfiguration.SqlQuery, param).FirstOrDefault();
            }
        }
        public int DynamicInsert(string tableName, string primaryKey, Dictionary<string, object> dictionary)
        {
            using (var context = DataContextHelper.GetCPDataContext(false))
            {
                string columnNames = string.Empty, columnValues = string.Empty;
                foreach (var item in dictionary)
                {
                    string[] keyWithType = item.Key.Split(new string[] { "##" }, StringSplitOptions.RemoveEmptyEntries);
                    columnNames += keyWithType[0] + ",";
                    if (Convert.ToBoolean(keyWithType[1]))
                    {
                        columnValues += "N'" + item.Value + "',";
                    }
                    else
                    {
                        columnValues += item.Value + ",";
                    }
                }
                columnNames = columnNames.TrimEnd(',');
                columnValues = columnValues.TrimEnd(',');
                var ppSql = string.Format("INSERT INTO {0} ({1}) OUTPUT INSERTED.{2} VALUES ({3})", tableName, columnNames, primaryKey, columnValues);
                return context.ExecuteScalar<int>(ppSql, null);
            }
        }
        public void DynamicUpdateWithCustom(string tableName, string primaryKey, object primaryKeyValue, Dictionary<string, object> dictionary)
        {
            using (var context = DataContextHelper.GetCPDataContext(false))
            {
                string columnNamesWithValues = string.Empty;
                Dictionary<string, object> poco = new Dictionary<string, object>();
                foreach (var item in dictionary)
                {
                    string[] keyWithType = item.Key.Split(new string[] { "##" }, StringSplitOptions.RemoveEmptyEntries);
                    columnNamesWithValues += keyWithType[0] + " = ";
                    if (Convert.ToBoolean(keyWithType[1]))
                    {
                        columnNamesWithValues += "N'" + item.Value + "',";
                    }
                    else
                    {
                        columnNamesWithValues += item.Value + ",";
                    }
                }
                columnNamesWithValues = columnNamesWithValues.TrimEnd(',');
                var ppSql = string.Format("UPDATE {0} SET {1} WHERE {2} = {3}", tableName, columnNamesWithValues, primaryKey, primaryKeyValue);
                context.Execute(ppSql, null);
                //context.Update(tableName, primaryKey, poco, primaryKeyValue, columns);
            }
        }
        public void DynamicDelete(string tableName, string column, object id)
        {
            using (var context = DataContextHelper.GetCPDataContext(false))
            {
                context.Execute(string.Format("Delete From {0} Where {1} = @0", tableName, column), id);
            }
        }
        public DynamicSetupScreen GetDynamicSetupScreen(string screenName)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Select("*").From("DynamicSetupScreens").Where("ScreenName = @0", screenName);
                return context.Fetch<DynamicSetupScreen>(sql).FirstOrDefault();
            }
        }
        public List<MenuNavigation> GetMenuNavigations()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Select("*").From("MenuNavigations").Where("IsActive = 1");
                return context.Fetch<MenuNavigation>(sql);
            }
        }
        public User GetUserByEmail(string email)
        {
            return ServiceExecutionHelper.Instance.GetDataAsync(() =>
            {
                using (var context = DataContextHelper.GetCPDataContext())
                {
                    var sql = PetaPoco.Sql.Builder
                        .Select("*").From("Users").Where("EmailAddress = @0", email);
                    return context.Fetch<User>(sql).FirstOrDefault();
                }
            });
        }

        #region Role(s) & Right(s)
        public List<Role> GetRoles()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*").From("Roles").Where("IsActive=1");
                return context.Fetch<Role>(ppSql);
            }
        }
        public List<Right> GetRights()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*").From("Rights").Where("IsActive=1");
                return context.Fetch<Right>(ppSql);
            }
        }
        public List<Entity> GetEntities()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*").From("Entities").Where("IsActive=1");
                return context.Fetch<Entity>(ppSql);
            }
        }
        public List<RoleRight> GetRolesRights(short roleID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var ppSql = PetaPoco.Sql.Builder.Select(@"*").From("RoleRights").Where("RoleID=@0", roleID);
                return context.Fetch<RoleRight>(ppSql);
            }
        }
        public string SaveRoleRights(List<RoleRight> roleRights, short roleID, int userID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                try
                {
                    string result = "Rights have been deleted";
                    context.BeginTransaction();
                    context.Execute("Delete From RoleRights Where RoleID = @0", roleID);
                    if (roleRights != null && roleRights.Count != 0)
                    {
                        foreach (var roleRight in roleRights)
                        {
                            roleRight.CreatedOn = DateTime.Now;
                            roleRight.ModifiedOn = DateTime.Now;
                            roleRight.CreatedBy = userID;
                            roleRight.ModifiedBy = userID;
                            context.Save(roleRight);
                        }
                        result = roleRights.Count.ToString() + " rights have been saved for the selected role.";
                    }
                    context.CompleteTransaction();
                    return result;
                }
                catch (Exception ex)
                {
                    return ex.Message;
                }

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
        #endregion

        #region Dashboard
        public List<DashboardSummary> GetDashboardSummary(int businessID)
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Append(@"Select 
	                            CAST(COUNT(0) AS NVARCHAR(25)) CountNo, 'NoOfBranches' ColumnName
                            From BusinessBranches Where BusinessID = @0
                            Union All
                            Select
	                            CAST(SUM(Points) AS NVARCHAR(25)) CountNo, 'SentPoints' ColumnName
                            From UserEarnedPoints Where BusinessID = @0
                            Union All
                            Select
	                            CAST(SUM(Points) AS NVARCHAR(25)) CountNo, 'ReceivedPoints' ColumnName
                            From UserConsumedPoints Where BusinessID = @0
                            Union All
                            Select
	                            CAST(COUNT(0) AS NVARCHAR(25)) CountNo, 'NoOfUsers' ColumnName
                            From Users Where BusinessID = @0
                            Union All
                            Select CAST(SP.Points AS NVARCHAR(25)) CountNo, 'NetPoints' ColumnName
                            From Subscriptions S
                            Inner Join SubscriptionPackages SP
                            On S.SubscriptionPackageID = SP.SubscriptionPackageID
                            Where BusinessID = @0 AND S.IsActive = 1
                            Union All
                            Select CAST(EndsOn AS NVARCHAR(25)) CountNo, 'ExpiryDate' ColumnName
                            From Subscriptions S Where BusinessID = @0 AND S.IsActive = 1", businessID);
                return context.Fetch<DashboardSummary>(sql);
            }
        }

        public List<DashboardSummary> GetDashboardSummary()
        {
            using (var context = DataContextHelper.GetCPDataContext())
            {
                var sql = PetaPoco.Sql.Builder
                    .Append(@"Select 
	                            CAST(COUNT(0) AS NVARCHAR(25)) CountNo, 'NoOfBusinesses' ColumnName
                            From Businesses
                            Union All
                            Select 
	                            CAST(COUNT(0) AS NVARCHAR(25)) CountNo, 'NoOfBranches' ColumnName
                            From BusinessBranches
                            Union All
                            Select
	                            CAST(SUM(Points) AS NVARCHAR(25)) CountNo, 'SentPoints' ColumnName
                            From UserEarnedPoints
                            Union All
                            Select
	                            CAST(SUM(Points) AS NVARCHAR(25)) CountNo, 'ReceivedPoints' ColumnName
                            From UserConsumedPoints
                            Union All
                            Select
	                            CAST(COUNT(0) AS NVARCHAR(25)) CountNo, 'NoOfUsers' ColumnName
                            From Users
                            Union All
                            Select CAST(SUM(SP.Points) AS NVARCHAR(25)) CountNo, 'NetPoints' ColumnName
                            From Subscriptions S
                            Inner Join SubscriptionPackages SP
                            On S.SubscriptionPackageID = SP.SubscriptionPackageID AND S.IsActive = 1");
                return context.Fetch<DashboardSummary>(sql);
            }
        }

        #endregion
    }
}
