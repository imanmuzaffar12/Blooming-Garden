using PetaPoco;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Framework.Shared.DataServices.CustomEntities
{
    public class DynamicPage
    {

        public string TableName { get; set; }
        public string PageTitle { get; set; }
        public List<DynamicField> Fields { get; set; }
        public List<DynamicField> SearchFields
        {
            get
            {
                List<DynamicField> searchFields = new List<DynamicField>();
                foreach (var f in this.Fields)
                {
                    if (f.IsString || f.IsForeignkey)
                    {
                        DynamicField sf = new DynamicField() { IsRequired = f.IsRequired, DbTypeID = f.DbTypeID, IsForeignkey = f.IsForeignkey, Name = f.Name, Disaplayble = f.Disaplayble, ValueColumnName = f.ValueColumnName, IsAutoID = f.IsAutoID, RefrencedTableData = f.RefrencedTableData, IsPrimaryKey = f.IsPrimaryKey, TextColumnName = f.TextColumnName, MaxLength = f.MaxLength, RefrencedTableName = f.RefrencedTableName };
                        searchFields.Add(sf);
                    }
                }
                return searchFields;
            }
        }
        public List<DynamicField> SearchFieldDisplay
        {
            get
            {
                List<DynamicField> searchFields = new List<DynamicField>();
                DynamicField df = new DynamicField();
                foreach (var f in this.SearchFields)
                {
                    if (f.IsString)
                    {
                        df.Name = df.Name + f.DisplayName + ",";
                    }
                    if (f.IsForeignkey)
                    {
                        f.Name = string.Format("SearchBy{0}", f.Name);
                        searchFields.Add(f);
                    }
                }
                df.DbTypeID = 99;// it is string
                searchFields.Add(df);
                return searchFields;
            }
        }
        public bool IsRecursive
        {
            get
            {
                if (string.IsNullOrEmpty(this.TableName))
                {
                    return false;
                }
                return this.Fields.Where(x => x.RefrencedTableName == this.TableName).FirstOrDefault() != null;
            }
        }
        public DynamicField ParentField
        {
            get
            {
                return this.Fields.Where(x => x.RefrencedTableName == this.TableName).FirstOrDefault();
            }
        }
        public DynamicField DisplayOrderField
        {
            get
            {
                return this.Fields.Where(x => x.Name.Contains("DisplaySeqNo") || x.Name.Contains("SequenceNo")).FirstOrDefault();
            }
        }
        public DynamicField PrimaryKeyField
        {
            get
            {
                return this.Fields.Where(x => x.IsPrimaryKey).FirstOrDefault();
            }
        }
        public bool AllowPaging
        {
            get
            {
                if (IsRecursive)
                    return false;
                if (this.DisplayOrderField != null)
                    return false;
                return false;
            }
        }
        public int? EntityID { get; set; }
    }
    public class DynamicField : EntityDetail
    {
        Dictionary<int, string> dic;
        public DynamicField()
        {
            dic = new Dictionary<int, string>();
            dic.Add(35, "String");
            dic.Add(36, "Guid");
            dic.Add(40, "DateTime");
            dic.Add(41, "DateTime");
            dic.Add(42, "DateTime");
            dic.Add(58, "DateTime");
            dic.Add(61, "DateTime");
            dic.Add(99, "String");
            dic.Add(167, "String");
            dic.Add(175, "String");
            dic.Add(239, "String");
            dic.Add(231, "String");
            dic.Add(48, "Short");
            dic.Add(52, "Int16");
            dic.Add(56, "Int32");
            dic.Add(127, "Int64");
            dic.Add(106, "Decimal");
            dic.Add(108, "Decimal");
            dic.Add(122, "Decimal");
            dic.Add(60, "Decimal");
            dic.Add(62, "Float");
            dic.Add(104, "Boolean");
            this.Disaplayble = true;
            this.AllowInGrid = true;
            this.GridOrder = 256;
        }
        [ResultColumn]
        public string Name
        {
            get
            {
                return this.ColumnName;
            }
            set
            {
                this.ColumnName = value;
            }
        }
        public string DisplayName
        {
            get
            {
                if (!string.IsNullOrEmpty(this.DisplayNameEn))
                {
                    return this.DisplayNameEn;
                }
                return this.Name.Sentencify();
            }
        }
        //[ResultColumn]
        //public bool AllowNulls 
        //{
        //    get { return this.IsRequired; }
        //    set { this.IsRequired = !value; }
        //}
        [ResultColumn]
        public int ProperMaxLength
        {
            get
            {
                if (this.IsUniCode)
                {
                    return this.MaxLength / 2;
                }
                return this.MaxLength;
            }
        }
        public bool Disaplayble { get; set; }

        public string ValueColumnName { get; set; }
        public string TextColumnName { get; set; }
        public bool AllowInGrid { get; set; }
        public int GridOrder { get; set; }
        public List<Dictionary<string, object>> RefrencedTableData { get; set; }
        public string FieldType
        {
            get { return dic.ContainsKey(this.DbTypeID) ? dic[this.DbTypeID] : null; }
        }
        public bool IsBoolean
        {
            get
            {
                return (this.FieldType == "Boolean");
            }
        }
        public bool IsString
        {
            get
            {
                return (this.FieldType == "String");
            }
        }
        public bool IsInt16
        {
            get
            {
                return (this.FieldType == "Int16");
            }
        }
        public bool IsInt32
        {
            get
            {
                return (this.FieldType == "Int32");
            }
        }
        public bool IsInt64
        {
            get
            {
                return (this.FieldType == "Int64");
            }
        }
        public bool IsDecimal
        {
            get
            {
                return (this.FieldType == "Decimal");
            }
        }
        public bool IsDateTime
        {
            get
            {
                return (this.FieldType == "DateTime");
            }
        }
        public bool IsUniCode
        {
            get
            {
                return (this.DbTypeID == 231);
            }
        }

    }
    public class DynamicEntityRow
    {
        [ResultColumn]
        public int FieldID { get; set; }
        [ResultColumn]
        public string FieldNameEn { get; set; }
        [ResultColumn]
        public string FieldNameAr { get; set; }
    }
    public class DynamicEntity : Entity
    {
    }
    public class DynamicEntityAttributEntity : Attribute
    {
        [ResultColumn]
        public int FieldID { get; set; }
        [ResultColumn]
        public string FieldNameEn { get; set; }
    }


    public class SubscriptionLicenseEntity
    {
        [ResultColumn]
        public int SubscriptionLicenseID { get; set; }
        [ResultColumn]
        public int LicenseID { get; set; }
        [ResultColumn]
        public string LicenseNameEn { get; set; }
        [ResultColumn]
        public int SectorID { get; set; }
        [ResultColumn]
        public string SectorName { get; set; }
        [ResultColumn]
        public int LevelID { get; set; }
        [ResultColumn]
        public string LevelNameEn { get; set; }
        [ResultColumn]
        public int NumberOfLicense { get; set; }
        [ResultColumn]
        public int Price { get; set; }
    }
    public class BusinessNetPointsEntity
    {
        public int SubscriptionID { get; set; }
        public int BusinessID { get; set; }
        public DateTime ExpiryDate { get; set; }
        public int NetPoints { get; set; }
        public int ReceivedPoints { get; set; }
        public int SentPoints { get; set; }
    }

}
