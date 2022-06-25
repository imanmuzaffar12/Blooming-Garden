using ArgaamPlus.CP.Application.Services;
using ArgaamPlus.Shared.DataServices;
using ArgaamPlus.Shared.Enums;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Web;

namespace ArgaamPlus.CP.Web.CommonCode.FSExcelImport
{
    //Author : Jomy John
    //Date : 09-Oct-2013
    public static class FSExcelImportHelper
    {

        public static FiscalPeriodEnum GetFiscalPeriod(string periodValue)
        {
            FiscalPeriodEnum retVal = FiscalPeriodEnum.YEAR;

            if (periodValue == "Annual")
            {
                retVal = FiscalPeriodEnum.YEAR;
            }
            else if (periodValue == "Q4")
            {
                retVal = FiscalPeriodEnum.Q4;
            }
            else if (periodValue == "Q3")
            {
                retVal = FiscalPeriodEnum.Q3;
            }
            else if (periodValue == "Q2")
            {
                retVal = FiscalPeriodEnum.Q2;
            }
            else if (periodValue == "Q1")
            {
                retVal = FiscalPeriodEnum.Q1;
            }
            else if (periodValue == "I4")
            {
                retVal = FiscalPeriodEnum.I4;
            }
            else if (periodValue == "I3")
            {
                retVal = FiscalPeriodEnum.I3;
            }
            else if (periodValue == "I2")
            {
                retVal = FiscalPeriodEnum.I2;
            }
            else if (periodValue == "I1")
            {
                retVal = FiscalPeriodEnum.I1;
            }
            return retVal;

        }


        public static string[] GetExcelSheetNames(string excelFile)
        {
            OleDbConnection objConn = null;
            System.Data.DataTable dt = null;

            try
            {
                string strConnectionString = "";

                if (excelFile.Trim().EndsWith(".xlsx"))
                {
                    strConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0 Xml;HDR=YES;IMEX=1\";", excelFile);
                }
                else if (excelFile.Trim().EndsWith(".xls"))
                {
                    strConnectionString = string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";", excelFile);
                }

                objConn = new OleDbConnection(strConnectionString);
                // Open connection with the database.
                objConn.Open();
                // Get the data table containg the schema guid.
                dt = objConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

                if (dt == null)
                {
                    return null;
                }

                string[] excelSheets = new string[dt.Rows.Count];
                int i = 0;

                // Add the sheet name to the string array.
                foreach (DataRow row in dt.Rows)
                {
                    excelSheets[i] = row["TABLE_NAME"].ToString().Trim('$', ' ', '\''); 
                    i++;
                }

                //// Loop through all of the sheets if you want too...
                //for (int j = 0; j < excelSheets.Length; j++)
                //{
                //    // Query each excel sheet.
                //}

                return excelSheets;
            }
            catch (Exception ex)
            {
                return null;
            }
            finally
            {
                // Clean up.
                if (objConn != null)
                {
                    objConn.Close();
                    objConn.Dispose();
                }
                if (dt != null)
                {
                    dt.Dispose();
                }
            }
        }

        public static string GetRangeByTemplate(int fsTemplateID)
        {
            //TODO
            // retrun range based on templateid
            return "A1:K188";
        }

        public static DataTable LoadXLS(string sheetName, string excelFileNameWithPath, string range)
        {
            DataTable dtXLS = new DataTable(sheetName);

            try
            {
                string strConnectionString = "";

                if (excelFileNameWithPath.Trim().EndsWith(".xlsx"))
                {

                    strConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0 Xml;HDR=YES;IMEX=1\";", excelFileNameWithPath);

                }
                else if (excelFileNameWithPath.Trim().EndsWith(".xls"))
                {

                    strConnectionString = string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";", excelFileNameWithPath);

                }

                OleDbConnection SQLConn = new OleDbConnection(strConnectionString);

                SQLConn.Open();

                OleDbDataAdapter SQLAdapter = new OleDbDataAdapter();

                string sql = "SELECT * FROM [" + sheetName + "$" + range + "]";

                OleDbCommand selectCMD = new OleDbCommand(sql, SQLConn);

                SQLAdapter.SelectCommand = selectCMD;

                SQLAdapter.Fill(dtXLS);

                SQLConn.Close();

            }

            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            return dtXLS;

        }

    }


    public static class ExcelDataLocations
    {
        internal const int YearColumn = 9;
        internal const int YearRow = 0;
        internal const int NumberOfDataColumn = 9;
        internal const int PeriodRow = 2;
        internal const int IsImportThisPeriodRow = 1;
    }
}