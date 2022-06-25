using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Linq;
using System.Web;

namespace Framework.Web.CommonCode.ExportResource
{
    public class ImportResource
    {

    }

    public class ImportExcelResource
    {
        public string FileName { get; set; }
        public object ExportModel { get; set; }
        public OleDbConnection Connection { get; set; }
        public OleDbDataReader ImportExcelData()
        {
            
            string strConnectionString = "";

            if (FileName.Trim().EndsWith(".xlsx"))
            {
                strConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0 Xml;HDR=YES;IMEX=1\";", FileName);
            }
            else if (FileName.Trim().EndsWith(".xls"))
            {
                strConnectionString = string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";", FileName);
            }

            this.Connection = new OleDbConnection(strConnectionString);
            // Open connection with the database.
            this.Connection.Open();
            dynamic myTableName = this.Connection.GetSchema("Tables").Rows[0]["TABLE_NAME"];
            OleDbCommand ocmd = new OleDbCommand("select * from [" + myTableName + "]", this.Connection);

            OleDbDataReader odr = ocmd.ExecuteReader();
            return odr;
            //if (odr.HasRows)
            //{
            //    while (odr.Read())
            //    {
            //        var model = new Student();
            //        model.Col1 = Convert.ToInt32(odr[0]);
            //        model.Col2 = odr[1].ToString().Trim();
            //        model.col3 = odr[2].ToString().Trim();
            //        model.col4 = odr[3].ToString().Trim();
            //        db.MyTable.AddObject(model);
            //    }
            //}
        }
    }
}