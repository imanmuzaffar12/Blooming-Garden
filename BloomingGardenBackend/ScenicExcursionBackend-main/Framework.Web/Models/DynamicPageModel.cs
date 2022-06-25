using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Framework.Shared.DataServices.CustomEntities;
using Framework.Shared.DataServices;
using Newtonsoft.Json;

namespace Framework.Web.Models
{
    public class DynamicPageModel
    {
        public DynamicPageModel()
        {
            this.IsNew = true;
            this.AllowAddEdit = true;
            this.AllowDelete = true;
            this.AllowPreview = false;
            this.ExcludeAddEditColumns = "";
            this.DontLoadRecursiveData = false;
            this.AllowImport = false;
        }
        public DynamicPage PageInfo { get; set; }
        public Dictionary<string, object> ObjectValues { get; set; }
        public List<Dictionary<string, object>> ListingData { get; set; }
        public bool AllowAddEdit { get; set; }
        public bool AllowImport { get; set; }
        public bool AllowSearchFilters { get; set; }
        public bool AllowListingGrid { get; set; }
        public bool AllowEdit { get; set; }
        public bool AllowDelete { get; set; }
        public bool AllowPreview { get; set; }
        public string GridColumns { get; set; }
        public bool IsNew { get; set; }
        public string GridColumnsString { get; set; }
        public string OrderBy { get; set; }
        public string ExcludeAddEditColumns { get; set; }
        public string ExcludeSearchColumns { get; set; }
        public string TableName { get; set; }
        public string Condition { get; set; }
        public string GridTitle { get; set; }
        public string ExtenderName { get; set; }

        public string CustomJavaScript { get; set; }
        public bool ShowAddNewButton { get; set; }
        public bool DontRenderJavaScript { get; set; }
        public Dictionary<string, object> CurrentRow { get; set; }
        public string CurrentLevel { get; set; }
        /// <summary>
        /// Marke it True if you want to Load all data in the DropDown not only data has parent valye as Null.
        /// </summary>
        public bool? DontLoadRecursiveData { get; set; }
        public string SecondaryTableConfigs { get; set; }
        public object Id { get; set; }
        public string DateFilters { get; set; }
        public string CustomQuery { get; set; }
        public bool? ShowAllGridColumns { get; set; }
        public bool ViewSelf { get; set; }
        public bool? AllowApprovals { get; set; }
    }

    public class DynamicAttributeModel
    {
        public string Title { get; set; }
        public DynamicEntity Entity { get; set; }
        public string EntityDisplayFieldName { get; set; }
        public string EntityValueFieldName { get; set; }
        public bool AutoComplete { get; set; }
        public List<DynamicEntityRow> EntityRows { get; set; }
        public List<DynamicEntityAttributEntity> SelectedAttributes { get; set; }
        public List<DynamicEntityAttributEntity> DynamicEntities { get; set; }
        public List<int> Years { get; set; }
        public int FiscalPeriodType { get; set; }
        public int Year { get; set; }
        public int RowID { get; set; }
    }
    public class EntityRelatedArticlesModel
    {
        public string Title { get; set; }
        public DynamicEntity Entity { get; set; }
        public string EntityDisplayFieldName { get; set; }
        public string EntityValueFieldName { get; set; }
        public bool AutoComplete { get; set; }
        public List<DynamicEntityRow> EntityRows { get; set; }
        public int RowID { get; set; }

    }

    public class Secondary_Table_Configs
    {
        [JsonProperty("Tables")]
        public List<Secondary_Orm> Tables { get; set; }
        //public List<Secondary_Orm> SecondaryTableConfigs { get; set; }
    }
    //'Table':'Sectors','Control':'DropDownList','Label':'Sectors'
    public class Secondary_Orm
    {
        [JsonProperty("SecondaryOrm")]
        public string SecondaryOrm { get; set; }
        [JsonProperty("Filters")]
        public List<Filters> Filters { get; set; }
        [JsonProperty("ForeignKey")]
        public string ForeignKey { get; set; }
        [JsonProperty("SavedRecordFields")]
        public string SavedRecordFields { get; set; }
        [JsonProperty("BeforeDelete")]
        public string BeforeDelete { get; set; }

        [JsonProperty("ForeignKeyAlies")]
        public string ForeignKeyAlies { get; set; }
        [JsonProperty("Alies")]
        public string Alies { get; set; }
        [JsonProperty("JoiningTables")]
        public string JoiningTables { get; set; }
        [JsonProperty("Settings")]
        public Settings Settings { get; set; }
        [JsonProperty("AdditionalFields")]
        public List<Additional_Fields> AdditionalFields { get; set; }
        [JsonProperty("FieldToSave")]
        public string FieldToSave { get; set; }
        [JsonProperty("TableToSaveRecords")]
        public string TableToSaveRecords { get; set; }
    }
    public class Settings
    {
        [JsonProperty("JoiningTables")]
        public string JoiningTables { get; set; }
        [JsonProperty("FieldToShow")]
        public List<FieldToShow> FieldToShow { get; set; }
        [JsonProperty("AllowAdd")]
        public bool AllowAdd { get; set; }
        [JsonProperty("AllowDelete")]
        public bool AllowDelete { get; set; }
        [JsonProperty("DisplaySeqNo")]
        public int DisplaySeqNo { get; set; }
    }
    public class FieldToShow
    {
        [JsonProperty("Name")]
        public string Name { get; set; }
        [JsonProperty("Type")]
        public string Type { get; set; }
        [JsonProperty("Alies")]
        public string Alies { get; set; }
        [JsonProperty("Label")]
        public string Label { get; set; }

    }
    public class Additional_Fields
    {
        [JsonProperty("Name")]
        public string Name { get; set; }
        [JsonProperty("Type")]
        public string Type { get; set; }
        [JsonProperty("Label")]
        public string Label { get; set; }
        [JsonProperty("IsRequired")]
        public bool IsRequired { get; set; }
    }
    public class AddEditGridRecordModel
    {
        public List<DynamicPageModel> DynamicPageModel { get; set; }
        public Secondary_Table_Configs SecondaryTableConfigs { get; set; }

        public List<Dictionary<string, object>> Records { get; set; }
        public List<Dictionary<string, object>> SavedRecords { get; set; }
        public List<List<Dictionary<string, object>>> Filters { get; set; }


        public string Configs { get; set; }
    }
    public class Filters
    {
        [JsonProperty("Table")]
        public string Table { get; set; }
        [JsonProperty("Control")]
        public string Control { get; set; }
        [JsonProperty("ControlLabel")]
        public string ControlLabel { get; set; }
        [JsonProperty("Label")]
        public string Label { get; set; }
        [JsonProperty("Value")]
        public string Value { get; set; }
        [JsonProperty("Columns")]
        public string Columns { get; set; }
    }

    public class DropDownListModel
    {
        public List<Dictionary<string, object>> Data { get; set; }
        public string ControlID { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public string TableName { get; set; }
    }

}