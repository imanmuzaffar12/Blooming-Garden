using Newtonsoft.Json;
using Framework.Application.Services;
using Framework.Web.CommonCode;
using Framework.Web.CommonCode.Helpers;
using Framework.Web.Models;
using Framework.Shared.DataServices;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using Framework.Shared.Enums;
using Framework.Shared.Helpers;
using System.IO;

namespace Framework.Web.Controllers
{
    public class DynamicController : BaseController
    {
        public ActionResult Index(string id)
        {

            ViewBag.TableName = id;
            return View();
        }
        public ActionResult TableForm(string tableName, string title, bool? allowAddEdit, bool? allowPreview, bool? allowSearchFilter, bool? allowListingGrid, string gridColumns,
            bool? allowDelete, bool? allowEdit, string excludeAddEditColumns,
            string excludeSearchColumns, bool? showAddNewButton, string condition, string gridTitle, string orderBy, bool? doNotRenderJavascript, string extenderName, string secondaryTableConfigs, bool? dontLoadRecursiveData,
            bool? allowImport, string customJavaScript, string dateFilters, string customQuery, bool? showAllGridColumns, bool? allowApprovals)
        {
            bool allowViewSelf = true;
            if (GlobalAppConfigs.EnableRoleRights)
            {
                if (Authentication.Instance.User == null
                    || Authentication.Instance.User.RolesRights == null
                    || Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower()) == null
                    || Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower()).Count() == 0)
                {
                    return View("Error");
                }
                else
                {
                    allowAddEdit = Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Add) != null && Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Add).Count() != 0 ? true : false;
                    allowEdit = Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Update) != null && Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Update).Count() != 0 ? true : false;
                    allowDelete = Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Delete) != null && Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.Delete).Count() != 0 ? true : false;
                    allowViewSelf = Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.ViewSelf) != null && Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.ViewSelf).Count() != 0 ? true : false;
                    allowViewSelf = Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.ViewAll) != null && Authentication.Instance.User.RolesRights.Where(x => x.EntityName.ToLower() == tableName.ToLower() && x.RightID == (short)RightsEnum.ViewAll).Count() != 0 ? false : true;
                }
            }
            else
            {
                allowViewSelf = false;
            }
            allowApprovals = allowApprovals ?? false;
            allowImport = allowImport ?? false;
            showAddNewButton = showAddNewButton.HasValue ? showAddNewButton.Value : true;
            allowAddEdit = allowAddEdit ?? true;
            allowListingGrid = allowListingGrid ?? true;
            allowSearchFilter = allowSearchFilter ?? true;
            allowDelete = allowDelete ?? true;
            allowEdit = allowEdit ?? true;
            allowPreview = allowPreview ?? false;
            DynamicPageModel model = new DynamicPageModel();
            model.ViewSelf = allowViewSelf;
            model.DontLoadRecursiveData = dontLoadRecursiveData;
            model.ExcludeSearchColumns = excludeSearchColumns;
            model.PageInfo = CommonServices.Instance.GetTablePage(tableName);
            model.AllowAddEdit = allowAddEdit.Value;
            model.AllowPreview = allowPreview.Value;
            model.AllowListingGrid = allowListingGrid.Value;
            model.AllowDelete = allowDelete.Value;
            model.AllowEdit = allowEdit.Value;
            model.AllowSearchFilters = allowSearchFilter.Value;
            model.TableName = tableName;
            model.GridColumns = gridColumns;
            model.GridTitle = gridTitle;
            model.ShowAddNewButton = showAddNewButton.Value;
            model.Condition = condition;
            model.AllowImport = allowImport.Value;
            model.ExtenderName = extenderName;
            model.CustomJavaScript = customJavaScript;
            model.DateFilters = dateFilters;
            model.CustomQuery = customQuery;
            model.ShowAllGridColumns = showAllGridColumns;
            model.AllowApprovals = allowApprovals;
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            model.SecondaryTableConfigs = jsonSerializer.Serialize(secondaryTableConfigs);
            if (doNotRenderJavascript.HasValue)
            {
                model.DontRenderJavaScript = doNotRenderJavascript.Value;
            }
            if (!string.IsNullOrEmpty(title))
            {
                model.PageInfo.PageTitle = title;
            }
            model.ObjectValues = new Dictionary<string, object>();
            foreach (var field in model.PageInfo.Fields)
            {
                if (field.IsGroup.HasValue && field.IsGroup.Value)
                {
                    continue;
                }
                if (field.IsForeignkey) //This will be used for search filled ups
                {
                    var refrencedTable = CommonServices.Instance.GetTablePage(field.RefrencedTableName);
                    var rFeilds = refrencedTable.Fields.Where(x => x.IsPrimaryKey || x.Name.Contains("Name") || x.Name.Contains("Value") || x.Name.Contains("Number") || x.Name.Contains("Description") || x.Name.Contains("Code")).Select(x => x.Name).ToList();
                    field.ValueColumnName = refrencedTable.Fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                    field.TextColumnName = EntityNameColumnName(refrencedTable.Fields, field.RefrencedTableName);
                    if (string.IsNullOrEmpty(field.TextColumnName))
                    {
                        field.TextColumnName = field.ValueColumnName;// refrencedTable.Fields.Where(x => !x.IsPrimaryKey).Select(x => x.ColumnName).FirstOrDefault();
                    }
                    //if (refrencedTable.IsRecursive)
                    //{
                    //    field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, refrencedTable.ParentField.Name);
                    //}
                    //else
                    //{
                    field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, null);
                    //}
                }
                if (!string.IsNullOrEmpty(gridColumns))
                {
                    field.GridOrder = Array.FindIndex(gridColumns.Split(",".ToCharArray()), row => row == field.ColumnName);
                }
                model.ObjectValues.Add(field.Name, null);
            }
            List<string> fileds = model.PageInfo.Fields.Where(x => !(x.IsGroup.HasValue && x.IsGroup.Value)).Select(x => x.Name).ToList();
            if (!string.IsNullOrEmpty(gridColumns))
            {
                foreach (var f in model.PageInfo.Fields)
                {
                    f.AllowInGrid = false;
                }
                int go = 0;
                foreach (string colName in gridColumns.Split(",".ToCharArray()))
                {
                    var f = model.PageInfo.Fields.Where(x => x.Name == colName).FirstOrDefault();
                    if (f != null)
                    {
                        f.AllowInGrid = true;
                        f.GridOrder = go;
                        go++;
                    }

                }
            }
            if (!string.IsNullOrEmpty(excludeAddEditColumns))
            {
                foreach (string excludeColumn in excludeAddEditColumns.Split(",".ToCharArray()))
                {
                    var f = model.PageInfo.Fields.Where(x => x.Name == excludeColumn).FirstOrDefault();
                    if (f != null)
                    {
                        f.Disaplayble = false;
                    }
                }
            }
            fileds.Add("TotalRecords = Count(*) Over()");//This is for total records
            model.IsNew = true;
            model.GridColumnsString = gridColumns;
            model.OrderBy = orderBy;

            model.ExcludeAddEditColumns = excludeAddEditColumns;
            Dictionary<string, object> searchFields = new Dictionary<string, object>();

            //model.ListingData = CommonServices.Instance.GetTableListingData(tableName, fileds, searchFields, string.Empty, null, 1, 20, model.PageInfo.AllowPaging, customCondition: condition, orderBy: orderBy);
            model.ListingData = CommonServices.Instance.GetTableListingData(tableName, fileds, searchFields, string.Empty, null, 1, 20, model.PageInfo.AllowPaging, customCondition: condition, orderBy: model.OrderBy, parentField: null, dateFilters: dateFilters, fromDate: null, toDate: null, customQuery: customQuery, viewSelf: allowViewSelf, userID: Authentication.Instance.User.UserID);
            return PartialView("TableFormV1", model);
        }
        private string EntityNameColumnName(List<Framework.Shared.DataServices.CustomEntities.DynamicField> fields, string tableName)
        {
            string columName = string.Format("{0}NameEn", tableName.Singlofy());
            if (fields.Where(x => x.ColumnName == columName).FirstOrDefault() != null)
            {
                return columName;
            }
            columName = "NameEn";
            if (fields.Where(x => x.ColumnName.EndsWith(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.EndsWith(columName)).FirstOrDefault().ColumnName;
            }

            columName = "FullName";
            if (fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault().ColumnName;
            }
            columName = "Code";
            if (fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault().ColumnName;
            }
            columName = "Name";
            if (fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault().ColumnName;
            }
            columName = "Number";
            if (fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault().ColumnName;
            }
            columName = "Description";
            if (fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault() != null)
            {
                return fields.Where(x => x.ColumnName.Contains(columName)).FirstOrDefault().ColumnName;
            }
            else
                return fields.Where(x => x.IsPrimaryKey).FirstOrDefault().ColumnName;
        }
        public ActionResult TableListing(FormCollection form)
        {
            DynamicPageModel model = new DynamicPageModel();
            string tableName = form["SearchTableName"];
            string searchTerm = form["SearchTerm"];
            string condition = form["Condition"];
            string orderBy = form["OrderBy"];
            string gridTitle = form["GridTitle"];
            bool ViewSelf = form["ViewSelf"] != null ? bool.Parse(form["ViewSelf"]) : false;
            string fromDate = string.Empty;
            string toDate = string.Empty;
            bool? showAllGridColumns = (bool?)null;
            if (form["FromDate"] != null)
            {
                fromDate = form["FromDate"];
            }
            if (form["ToDate"] != null)
            {
                toDate = form["ToDate"];
            }
            int pageNo = form["PageNo"] != null ? int.Parse(form["PageNo"]) : 1;
            string gridColumns = form["GridColumns"];
            string excludeSearchColumns = form["ExcludeSearchColumns"];
            bool allowEdit = bool.Parse(form["AllowEdit"].ToString());
            bool allowPreview = bool.Parse(form["AllowPreview"].ToString());
            bool allowDelete = bool.Parse(form["AllowDelete"].ToString());
            string dateFilters = form["DateFilters"].ToString();
            string customQuery = form["CustomQuery"].ToString();
            if (form["ShowAllGridColumns"] != null)
            {
                showAllGridColumns = bool.Parse(form["ShowAllGridColumns"].ToString());
            }
            model.CustomQuery = customQuery;
            bool dontLoadRecursiveData = false;
            if (form["DontLoadRecursiveData"] != null)
            {
                dontLoadRecursiveData = bool.Parse(form["DontLoadRecursiveData"]);
            }
            model.AllowPreview = allowPreview;
            model.DontLoadRecursiveData = dontLoadRecursiveData;
            model.ShowAllGridColumns = showAllGridColumns;
            int pageSize = 20;//TODO: This should be configurable 
            model.PageInfo = CommonServices.Instance.GetTablePage(tableName);
            model.GridColumns = gridColumns;
            List<string> fileds = model.PageInfo.Fields.Where(x => !(x.IsGroup.HasValue && x.IsGroup.Value)).Select(x => x.Name).ToList();
            fileds.Add("TotalRecords = Count(*) Over()");//This is for total records
            model.TableName = tableName;
            model.OrderBy = orderBy;
            model.ExtenderName = form["ExtenderName"];
            Dictionary<string, object> searchFields = new Dictionary<string, object>();
            foreach (string key in form.Keys)
            {
                if (key == "SearchTableName" || key == "PageNo" || key == "SearchTerm" || key == "GridColumns" || key == "AllowEdit" || key == "AllowDelete" || key == "AllowPreview" || key == "ExcludeSearchColumns" || key.Contains("Filter") || key == "GridTitle" || key == "ExtenderName" || key == "Condition" || key == "OrderBy" || key == "DontLoadRecursiveData" || key == "FromDate" || key == "ToDate" || key == "DateFilters" || key == "CustomQuery" || key == "ShowAllGridColumns" || key == "ViewSelf" || key == "AllowApprovals" || key == "TableEntityID")
                {
                    continue;
                }
                if (!string.IsNullOrEmpty(form[key]) && form[key].ToString() != "0")
                {
                    searchFields.Add(key.Replace("SearchBy", ""), form[key]);
                }
            }
            model.ObjectValues = new Dictionary<string, object>();
            foreach (var field in model.PageInfo.Fields)
            {
                if (field.IsGroup.HasValue && field.IsGroup.Value)
                {
                    continue;
                }
                if (field.IsForeignkey) //This will be used for search filled ups
                {
                    var refrencedTable = CommonServices.Instance.GetTablePage(field.RefrencedTableName);
                    var rFeilds = refrencedTable.Fields.Where(x => x.IsPrimaryKey || x.Name.Contains("Name") || x.Name.Contains("Value") || x.Name.Contains("Number") || x.Name.Contains("Description")).Select(x => x.Name).ToList();
                    field.ValueColumnName = refrencedTable.Fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                    // field.TextColumnName = refrencedTable.Fields.Where(x => x.Name.Contains("Name") || x.Name.Contains("Value")).Select(x => x.Name).OrderBy(x => x).FirstOrDefault();
                    field.TextColumnName = EntityNameColumnName(refrencedTable.Fields, field.RefrencedTableName);
                    if (string.IsNullOrEmpty(field.TextColumnName))
                    {
                        field.TextColumnName = field.ValueColumnName;// refrencedTable.Fields.Where(x => !x.IsPrimaryKey).Select(x => x.ColumnName).FirstOrDefault();
                    }
                    //if (refrencedTable.IsRecursive)
                    //{
                    //    field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, refrencedTable.ParentField.Name);
                    //}
                    //else
                    //{
                    if (Authentication.Instance.User.RoleID == (int)RolesEnum.Merchants)
                    {
                        field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, string.Empty, null, model.OrderBy, null, null, null, null, ViewSelf, Authentication.Instance.User.UserID);
                    }
                    else
                    {
                        field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, string.Empty, null);
                    }
                    //}
                }

                if (!string.IsNullOrEmpty(gridColumns))
                {
                    field.GridOrder = Array.FindIndex(gridColumns.Split(",".ToCharArray()), row => row == field.ColumnName);
                }
                model.ObjectValues.Add(field.Name, null);
            }
            List<string> searchTermFields = model.PageInfo.SearchFields.Where(x => x.IsString && !(x.IsGroup.HasValue && x.IsGroup.Value)).Select(c => c.Name).ToList();
            if (!string.IsNullOrEmpty(gridColumns))
            {
                foreach (var f in model.PageInfo.Fields)
                {
                    f.AllowInGrid = false;
                }
                int go = 0;
                foreach (string colName in gridColumns.Split(",".ToCharArray()))
                {
                    var f = model.PageInfo.Fields.Where(x => x.Name == colName).FirstOrDefault();
                    if (f != null)
                    {
                        f.AllowInGrid = true;
                        f.GridOrder = go;
                        go++;
                    }

                }
            }
            model.Condition = condition;
            model.ListingData = CommonServices.Instance.GetTableListingData(tableName, fileds, searchFields, searchTerm, searchTermFields, pageNo, pageSize, model.PageInfo.AllowPaging, customCondition: condition, orderBy: model.OrderBy, parentField: null, dateFilters: dateFilters, fromDate: fromDate, toDate: toDate, customQuery: customQuery, viewSelf: ViewSelf, userID: Authentication.Instance.User.UserID);
            model.GridColumnsString = gridColumns;
            model.AllowEdit = allowEdit;
            model.AllowDelete = allowDelete;
            model.GridTitle = gridTitle;
            model.ExcludeSearchColumns = excludeSearchColumns;
            //if (model.PageInfo.IsRecursive)
            //{
            //    if (model.ListingData.OrderBy(x => x[model.PageInfo.DisplayOrderField.Name]).Where(x => x[model.PageInfo.ParentField.Name] == null).Count() == 0)
            //    {
            //        foreach (var v in model.ListingData)
            //        {
            //            v[model.PageInfo.ParentField.Name] = null;
            //        }
            //    }
            //    return PartialView("_TableListingRecursive", model);
            //}
            //if (model.PageInfo.DisplayOrderField != null)
            //{
            //    return PartialView("_TableListingReOrder", model);
            //}
            return PartialView("_TableListing", model);
        }
        public ActionResult AddEditTableRecord(string tableName, object id, string excludeAddEditColumns, string extenderName, string secondaryTableConfigs, bool? dontLoadRecursiveData, bool? allowApprovals, short? tableEntityID)
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            var test = json.Serialize(secondaryTableConfigs);
            dontLoadRecursiveData = dontLoadRecursiveData ?? false;
            DynamicPageModel model = new DynamicPageModel();
            model.PageInfo = CommonServices.Instance.GetTablePage(tableName);
            model.ExtenderName = extenderName;
            model.SecondaryTableConfigs = secondaryTableConfigs;
            model.AllowApprovals = allowApprovals;
            model.Id = id;
            model.PageInfo.EntityID = tableEntityID;
            model.ObjectValues = new Dictionary<string, object>();
            foreach (var field in model.PageInfo.Fields)
            {
                if (field.IsForeignkey)
                {
                    var refrencedTable = CommonServices.Instance.GetTablePage(field.RefrencedTableName);
                    var rFeilds = refrencedTable.Fields.Where(x => x.IsPrimaryKey || x.Name.Contains("Name") || x.Name.Contains("Value") || x.Name.Contains("Number") || x.Name.Contains("Description") || x.Name.Contains("Code")).Select(x => x.Name).ToList();
                    field.ValueColumnName = refrencedTable.Fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                    //field.TextColumnName = refrencedTable.Fields.Where(x => x.Name.Contains("Name") || x.Name.Contains("Value")).Select(x => x.Name).OrderBy(x => x).FirstOrDefault();
                    field.TextColumnName = EntityNameColumnName(refrencedTable.Fields, field.RefrencedTableName);
                    if (string.IsNullOrEmpty(field.TextColumnName))
                    {
                        field.TextColumnName = field.ValueColumnName;// refrencedTable.Fields.Where(x => !x.IsPrimaryKey).Select(x => x.ColumnName).FirstOrDefault();
                    }
                    //if (refrencedTable.IsRecursive && !dontLoadRecursiveData.Value)
                    //{
                    //    field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false,parentField:refrencedTable.ParentField.Name, customCondition:null,orderBy:null);
                    //}
                    //else
                    //{
                    field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, string.Empty);
                    //}
                }
                #region Created and Modified
                if (field.Name.ToLower() == "createdon" || field.Name.ToLower() == "modifiedon" || field.Name.ToLower() == "lastmodifiedon" || field.Name.ToLower() == "createddate")
                {
                    model.ObjectValues.Add(field.Name, DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));

                }
                else if (field.Name.ToLower() == "createdby" || field.Name.ToLower() == "modifiedby" || field.Name.ToLower() == "lastmodifiedby")
                {
                    model.ObjectValues.Add(field.Name, Authentication.Instance.User.UserID);
                }
                else
                {
                    model.ObjectValues.Add(field.Name, null);
                }
                #endregion

                if (!string.IsNullOrEmpty(excludeAddEditColumns))
                {
                    if (excludeAddEditColumns.Split(",".ToCharArray()).Contains(field.Name))
                    {
                        field.Disaplayble = false;
                    }
                }
            }
            if (!string.IsNullOrEmpty(id.ToString()) && id.ToString() != "0")
            {
                Dictionary<string, object> sfeilds = new Dictionary<string, object>();
                string key = model.PageInfo.Fields.Where(c => c.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                sfeilds.Add(key, id);
                var val = CommonServices.Instance.GetTableSingleRecord(tableName, model.PageInfo.Fields.Where(x => !(x.IsGroup.HasValue && x.IsGroup.Value)).Select(x => x.Name).ToList(), sfeilds);
                if (val != null)
                {
                    model.ObjectValues = val;
                    string uOn, uby, pass; uOn = uby = pass = "";
                    foreach (string k in val.Keys)
                    {
                        if (k.ToLower() == "modifiedon" || k.ToLower() == "lastmodifiedon")
                        {
                            uOn = k;
                        }
                        else if (k.ToLower() == "modifiedby" || k.ToLower() == "lastmodifiedby")
                        {
                            uby = k;
                        }

                        else if (k.ToLower() == "password")
                        {
                            pass = k;
                        }
                    }
                    model.ObjectValues[uOn] = DateTime.Now;
                    model.ObjectValues[uby] = Authentication.Instance.User.UserID;
                    if (!string.IsNullOrEmpty(pass) && model.ObjectValues[pass] != null)
                    {
                        model.ObjectValues[pass] = model.ObjectValues[pass].ToString().Decrypt();
                    }
                    model.IsNew = false;
                }
                else
                {
                    model.IsNew = true;
                }
            }
            model.ExcludeAddEditColumns = excludeAddEditColumns;
            //model.IsNew = (id.ToString() == "0" || string.IsNullOrEmpty(id.ToString()));
            List<string> fileds = model.PageInfo.Fields.Select(x => x.Name).ToList();
            return PartialView("_AddEditTableRecord", model);
        }
        public ActionResult AddEditGridRecord(string tableName, int? id)
        {
            AddEditGridRecordModel addEditGridRecordModel = new AddEditGridRecordModel();
            addEditGridRecordModel.SecondaryTableConfigs = JsonConvert.DeserializeObject<Secondary_Table_Configs>(tableName.Replace("&quot;", ""));
            foreach (var data in addEditGridRecordModel.SecondaryTableConfigs.Tables)
            {
                string whereCondition = string.Empty;
                addEditGridRecordModel.Records = CommonServices.Instance.GetTableListingData(string.Format("{0} {1}", data.SecondaryOrm, data.Alies), string.Join(",", data.Settings.FieldToShow.Select(x => x.Alies).ToArray()), data.Settings.JoiningTables, string.Empty);
                if (id.HasValue && id.Value != 0)
                {
                    whereCondition = string.Format("{0}.{1} = {2}", data.ForeignKeyAlies, data.ForeignKey, id.Value);
                    addEditGridRecordModel.SavedRecords = CommonServices.Instance.GetTableListingData(string.Format("{0} {1}", data.SecondaryOrm, data.Alies), data.SavedRecordFields, string.Format("{0} {1}", data.Settings.JoiningTables, data.JoiningTables), whereCondition);

                }
                if (addEditGridRecordModel.SecondaryTableConfigs != null
                    && addEditGridRecordModel.SecondaryTableConfigs.Tables != null
                    && addEditGridRecordModel.SecondaryTableConfigs.Tables[0].Filters != null)
                {
                    addEditGridRecordModel.Filters = new List<List<Dictionary<string, object>>>();
                    foreach (var filterConfig in addEditGridRecordModel.SecondaryTableConfigs.Tables[0].Filters)
                    {
                        addEditGridRecordModel.Filters.Add(CommonServices.Instance.GetTableListingData(filterConfig.Table, filterConfig.Columns, string.Empty, string.Empty));

                    }
                }
            }
            addEditGridRecordModel.Configs = tableName;
            #region Commented
            //List<DynamicPageModel> list = new List<DynamicPageModel>();
            //foreach (var secondaryOrm in json.Tables)
            //{
            //    DynamicPageModel model = new DynamicPageModel();
            //    model.PageInfo = CommonServices.Instance.GetTablePage(secondaryOrm.SecondaryOrm, secondaryOrm.Settings.FieldToShow);
            //    model.ExtenderName = extenderName;
            //    model.TableName = secondaryOrm.SecondaryOrm;
            //    model.ObjectValues = new Dictionary<string, object>();
            //    foreach (var field in model.PageInfo.Fields)
            //    {
            //        if (field.IsForeignkey)
            //        {
            //            var refrencedTable = CommonServices.Instance.GetTablePage(field.RefrencedTableName);
            //            var rFeilds = refrencedTable.Fields.Where(x => x.IsPrimaryKey || x.Name.Contains("Name") || x.Name.Contains("Value")).Select(x => x.Name).ToList();
            //            field.ValueColumnName = refrencedTable.Fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
            //            //field.TextColumnName = refrencedTable.Fields.Where(x => x.Name.Contains("Name") || x.Name.Contains("Value")).Select(x => x.Name).OrderBy(x => x).FirstOrDefault();
            //            field.TextColumnName = EntityNameColumnName(refrencedTable.Fields, field.RefrencedTableName);
            //            if (string.IsNullOrEmpty(field.TextColumnName))
            //            {
            //                field.TextColumnName = field.ValueColumnName;// refrencedTable.Fields.Where(x => !x.IsPrimaryKey).Select(x => x.ColumnName).FirstOrDefault();
            //            }
            //            field.RefrencedTableData = CommonServices.Instance.GetTableListingData(field.RefrencedTableName, rFeilds, null, string.Empty, null, 1, 100, false, string.Empty);
            //        }
            //        #region Created and Modified
            //        if (field.Name.ToLower() == "createdon" || field.Name.ToLower() == "modifiedon" || field.Name.ToLower() == "lastmodifiedon" || field.Name.ToLower() == "createddate")
            //        {
            //            model.ObjectValues.Add(field.Name, DateTime.Now);

            //        }
            //        else if (field.Name.ToLower() == "createdby" || field.Name.ToLower() == "modifiedby" || field.Name.ToLower() == "lastmodifiedby")
            //        {
            //            model.ObjectValues.Add(field.Name, Authentication.Instance.User.UserID);
            //        }
            //        else
            //        {
            //            model.ObjectValues.Add(field.Name, null);
            //        }
            //        #endregion
            //        if (!string.IsNullOrEmpty(excludeAddEditColumns))
            //        {
            //            if (excludeAddEditColumns.Split(",".ToCharArray()).Contains(field.Name))
            //            {
            //                field.Disaplayble = false;
            //            }
            //        }
            //    }
            //    if (!string.IsNullOrEmpty(id.ToString()) && id.ToString() != "0")
            //    {
            //        Dictionary<string, object> sfeilds = new Dictionary<string, object>();
            //        string key = model.PageInfo.Fields.Where(c => c.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
            //        sfeilds.Add(key, id);
            //        var val = CommonServices.Instance.GetTableSingleRecord(tableName, model.PageInfo.Fields.Where(x => !(x.IsGroup.HasValue && x.IsGroup.Value)).Select(x => x.Name).ToList(), sfeilds);
            //        if (val != null)
            //        {
            //            model.ObjectValues = val;
            //            string uOn, uby; uOn = uby = "";
            //            foreach (string k in val.Keys)
            //            {
            //                if (k.ToLower() == "modifiedon" || k.ToLower() == "lastmodifiedon")
            //                {
            //                    uOn = k;
            //                }
            //                else if (k.ToLower() == "modifiedby" || k.ToLower() == "lastmodifiedby")
            //                {
            //                    uby = k;
            //                }
            //            }
            //            model.ObjectValues[uOn] = DateTime.Now;
            //            model.ObjectValues[uby] = Authentication.Instance.User.UserID;
            //            model.IsNew = false;
            //        }
            //        else
            //        {
            //            model.IsNew = true;
            //        }
            //    }

            //    model.ExcludeAddEditColumns = excludeAddEditColumns;
            //    List<string> fileds = model.PageInfo.Fields.Select(x => x.Name).ToList();
            //    list.Add(model);
            //}
            //addEditGridRecordModel.DynamicPageModel = list;
            //return PartialView("_AddEditGridRecord", addEditGridRecordModel);
            #endregion
            return PartialView("_AddEditGridRecord", addEditGridRecordModel);
        }
        [ValidateInput(false)]
        [HttpPost]
        public JsonResult SaveUpdateTableRecord(FormCollection form)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            string tableName = form["TableName"] != null ? form["TableName"] : string.Empty;
            string extenderName = form["ExtenderName"] != null ? form["ExtenderName"] : string.Empty;

            var fields = CommonServices.Instance.GetTablePage(tableName).Fields;
            // string pkColumn = fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
            Dictionary<string, object> record = new Dictionary<string, object>();
            bool isNew = bool.Parse(form["IsNew"].ToString());
            foreach (string key in form.Keys)
            {

                if (key != "TableName" || key != "IsNew" || key != "ExtenderName" || key != "AllowApprovals" && key != "TableEntityID")
                {
                    if (key == "LastUpdatedOn" && string.IsNullOrEmpty(form[key]))
                    {
                        record.Add(key, DateTime.Now.ToString());
                    }
                    else if (key == "LastUpdatedBy" && string.IsNullOrEmpty(form[key]))
                    {
                        record.Add(key, Authentication.Instance.User.UserID.ToString());
                    }
                    else if (key == "ModifiedOn")
                    {
                        record.Add(key, DateTime.Now.ToString());
                    }
                    else if (key == "ModifiedBy")
                    {
                        record.Add(key, Authentication.Instance.User.UserID.ToString());
                    }
                    else if (key == "CreatedOn" && string.IsNullOrEmpty(form[key]))
                    {
                        record.Add(key, DateTime.Now.ToString());
                    }
                    else if (key == "CreatedBy" && string.IsNullOrEmpty(form[key]))
                    {
                        record.Add(key, Authentication.Instance.User.UserID.ToString());
                    }
                    else if (key == "Password" && !string.IsNullOrEmpty(form[key]))
                    {
                        record.Add(key, form[key].Encrypt());
                    }
                    else
                    {
                        record.Add(key, form[key]);
                    }
                }

            }
            if (isNew)
            {
                foreach (var f in fields)
                {
                    if (f.Name.ToLower() == "updatedby" || f.Name.ToLower() == "lastmodifiedby" || f.Name.ToLower() == "updatedon" || f.Name.ToLower() == "lastmodifiedon")
                    {
                        record.Remove(f.Name);
                    }
                }
                try
                {
                    DynamicExtender extender = null;
                    if (!string.IsNullOrEmpty(extenderName))
                    {
                        extender = this.GetExtandered(extenderName);
                    }
                    if (extender != null)
                    {
                        var obj = CommonServices.Instance.ToPocoObject(tableName, fields, record);
                        if (!extender.IsValidToSave(obj))
                        {
                            throw (new InvalidOperationException(""));
                            //result.Data = new { Success = false, Message = string.Format("Unable to create {0}, {1}", tableName.Singlofy().Wordify(), extender.ValidationMessage(obj)) };
                        }
                    }
                    if (extender != null)
                    {
                        var obj = CommonServices.Instance.ToPocoObject(tableName, fields, record);
                        extender.BeforeSave(obj, form);
                    }
                    var poco = CommonServices.Instance.SaveTableRecord(tableName, fields, record);
                    if (extender != null)
                    {
                        extender.AfterSave(poco, form);
                    }
                    result.Data = new { Success = true, Message = string.Format("{0} saved successfuly.", tableName.Singlofy()) };
                }
                catch (Exception ex)
                {
                    if (ex.Source == "Extender")
                    {
                        result.Data = new { Success = false, Message = ex.Message, DevMessage = ex.Message };
                    }
                    else
                    {
                        result.Data = new { Success = false, DevMessage = ex.Message, Message = string.Format("Unable to create {0}, Please try again.", tableName.Singlofy().Wordify()) };
                    }
                }
            }
            else
            {

                try
                {
                    DynamicExtender extender = null;
                    if (!string.IsNullOrEmpty(extenderName))
                    {
                        extender = this.GetExtandered(extenderName);
                    }
                    if (extender != null)
                    {
                        var obj = CommonServices.Instance.ToPocoObject(tableName, fields, record);
                        if (!extender.IsValidToSave(obj))
                        {
                            throw (new InvalidOperationException(""));
                            //result.Data = new { Success = false, Message = string.Format("Unable to create {0}, {1}", tableName.Singlofy().Wordify(), extender.ValidationMessage(obj)) };
                        }
                    }
                    if (extender != null)
                    {
                        var obj = CommonServices.Instance.ToPocoObject(tableName, fields, record);
                        extender.BeforeUpdate(obj, form, null);
                    }
                    var poco = CommonServices.Instance.UpdateTableRecord(tableName, fields, record);
                    if (extender != null)
                    {
                        string pkColumn = fields.Where(x => x.IsPrimaryKey).Select(x => x.Name).FirstOrDefault();
                        var id = record[pkColumn];
                        extender.AfterUpdate(poco, form, id);
                    }
                    result.Data = new { Success = true, Message = string.Format("{0} updated successfuly.", tableName.Singlofy()) };

                }
                catch (Exception ex)
                {
                    if (ex.Source == "Extender")
                    {
                        result.Data = new { Success = false, Message = ex.Message, DevMessage = ex.Message };
                    }
                    else
                    {
                        result.Data = new { Success = false, Message = string.Format("Unable to Update {0}, Please try again!.", tableName.Singlofy().Wordify(), ex.Message), DevMessage = ex.Message };
                    }
                }

            }
            return result;
        }
        public JsonResult DeleteRecord(string tableName, string fieldName, object id, string configs, string extenderName = null)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            extenderName = !string.IsNullOrEmpty(extenderName) ? extenderName : string.Empty;
            var fields = CommonServices.Instance.GetTablePage(tableName).Fields;
            Dictionary<string, object> record = new Dictionary<string, object>();
            try
            {
                DynamicExtender extender = null;
                if (!string.IsNullOrEmpty(extenderName))
                {
                    extender = this.GetExtandered(extenderName);
                }

                if (extender != null)
                {
                    var obj = CommonServices.Instance.GetTableRecordForDelete(tableName, fieldName, id);
                    extender.BeforeDelete(obj, null, id, configs);
                }

                //if (extender != null)
                //{
                //    extender.AfterDelete(poco, null);
                //}
                result.Data = new { Success = true, Message = string.Format("{0} delete successfuly.", tableName.Singlofy()) };
            }
            catch (Exception ex)
            {
                if (ex.Source == "Extender")
                {
                    result.Data = new { Success = false, Message = ex.Message, DevMessage = ex.Message };
                }
                else
                {
                    result.Data = new { Success = false, DevMessage = ex.Message, Message = string.Format("Unable to delete {0}, Please try again.", tableName.Singlofy().Wordify()) };
                }
            }
            try
            {

                CommonServices.Instance.DeleteTableRecord(tableName, fieldName, id);
                result.Data = new { Success = true, Message = string.Format("{0} record with {1} deleted", tableName.Singlofy(), fieldName.Singlofy()) };
            }
            catch (Exception ex)
            {
                result.Data = new { Success = false, Message = string.Format("Unable to delete, this record might be refrenced by some child record."), ActualErrorMessage = ex.Message };
            }

            return result;
        }
        public JsonResult UpdateDisplayOrders(FormCollection form)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            string tableName = form["TableName"] != null ? form["TableName"] : string.Empty;
            string pks = form["OrderedPKs"] != null ? form["OrderedPKs"] : string.Empty;
            var fields = CommonServices.Instance.GetTablePage(tableName).Fields;
            var displayOrder = fields.Where(x => x.Name.Contains("DisplaySeqNo") || x.Name.Contains("SequenceNo")).FirstOrDefault();
            var pkField = fields.Where(x => x.IsPrimaryKey).FirstOrDefault();
            if (displayOrder != null)
            {
                CommonServices.Instance.UpdateTableDisplayOrders(tableName, displayOrder.Name, pkField.Name, pks);
                result.Data = new { Success = true };
            }
            else
            {
                result.Data = new { Success = false, Message = "This functionality is not supported on this Entity." };
            }
            return result;
        }
        public JsonResult ResetDisplayOrders(FormCollection form)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            string tableName = form["TableName"] != null ? form["TableName"] : string.Empty;

            var fields = CommonServices.Instance.GetTablePage(tableName).Fields;
            var displayOrder = fields.Where(x => x.Name.Contains("DisplaySeqNo") || x.Name.Contains("SequenceNo")).FirstOrDefault();
            var pkField = fields.Where(x => x.IsPrimaryKey).FirstOrDefault();
            if (displayOrder != null)
            {
                CommonServices.Instance.ResetTableDisplayOrders(tableName, displayOrder.Name);
                result.Data = new { Success = true };
            }
            else
            {
                result.Data = new { Success = false, Message = "This functionality is not supported on this Entity." };
            }
            return result;
        }
        private DynamicExtender GetExtandered(string name)
        {
            var obj = Activator.CreateInstance("Framework.Web", string.Format("Framework.Web.CommonCode.{0}", name));
            return (DynamicExtender)obj.Unwrap();
        }
        public JsonResult DynamicAutoComplete(string entityName, string displayField, string valueField)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            result.Data = CommonServices.Instance.GetEntityRows(entityName, displayField, valueField);
            return result;
        }
        [HttpPost]
        public ActionResult UploadFiles()
        {
            bool isSuccess = false;
            string serverMessage = string.Empty;
            var fileOne = Request.Files[0] as HttpPostedFileBase;
            string fileName = Guid.NewGuid().ToString() + ".jpg";
            var path = Path.Combine(HttpRuntime.AppDomainAppPath, @"Uploads\" + fileName);
            fileOne.SaveAs(path);

            if (System.IO.File.Exists(path))
            {
                isSuccess = true;
                serverMessage = "Files have been uploaded successfully";
            }
            else
            {
                isSuccess = false;
                serverMessage = "Files upload is failed. Please try again.";
            }
            return Json(new { IsSucccess = isSuccess, ServerMessage = serverMessage, Path = Request.Url.AbsoluteUri.Replace(Request.RawUrl, "") + "/Uploads/" + fileName }, JsonRequestBehavior.AllowGet);
        }

    }
}
