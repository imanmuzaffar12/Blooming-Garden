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
    public class FSExcelImport
    {

        private string ExcelFileNameWithPath { get; set; }
        private int CompanyID { get; set; }
        private string ExcelSheetRange { get; set; }
        private short ArgaamSectorTemplateID { get; set; }
        private FSTemplate FSTemplate { get; set; }
        private List<FSTemplateFieldListEntity> FSOrderedTemplateFields { get; set; }
        private short ForYear { get; set; }
        private int UpdateUserID { get; set; }
        private FiscalPeriodEnum FiscalPeriod { get; set; }
        private DataTable ExcelData { get; set; }

        public FSExcelImport(int companyID, int fsTemplateID, short argaamSectorTemplateID, int updateBy, string excelFileNameWithPath)
        {
            this.ExcelFileNameWithPath = excelFileNameWithPath;
            this.CompanyID = companyID;
            this.ArgaamSectorTemplateID = argaamSectorTemplateID;
            this.UpdateUserID = updateBy;
            this.FSTemplate = FinancialServices.Instance.GetFSTemplateByID(fsTemplateID);
            this.FSOrderedTemplateFields = FinancialServices.Instance.GetOrderedFSTemplateFieldsForDE(this.FSTemplate.FSTemplateID, this.FSTemplate.ParentTemplateID);
            this.ExcelSheetRange = FSExcelImportHelper.GetRangeByTemplate(this.FSTemplate.FSTemplateID);
        }

        public bool ImportExcelFileData()
        {
            bool retVal = true;

            foreach (string sheetName in FSExcelImportHelper.GetExcelSheetNames(ExcelFileNameWithPath))
            {
                if (!sheetName.EndsWith("Y"))
                {
                    continue;
                }

                this.ExcelData = FSExcelImportHelper.LoadXLS(sheetName, this.ExcelFileNameWithPath, this.ExcelSheetRange);
                string forYearStr = (string)ExcelData.Rows[ExcelDataLocations.YearRow][ExcelDataLocations.YearColumn];
                this.ForYear = short.Parse(forYearStr);

                for (int columnNo = 1; columnNo <= ExcelDataLocations.NumberOfDataColumn; columnNo++)
                {
                    var exRow = ExcelData.Rows[ExcelDataLocations.IsImportThisPeriodRow][columnNo];
                    if (exRow == DBNull.Value)
                    {
                        continue;
                    }

                    string confirmVal = (string)exRow;

                    if (confirmVal.Trim() != "Y")
                    {
                        continue;
                    }

                    string periodValue = (string)ExcelData.Rows[ExcelDataLocations.PeriodRow][columnNo];
                    this.FiscalPeriod = FSExcelImportHelper.GetFiscalPeriod(periodValue);
                    ImportData(columnNo);
                }

            }
            return retVal;
        }
        private bool ImportData(int columnNo)
        {
            bool retVal = false;

            using (var context = DataContextHelper.GetCPDataContext())
            {
                context.KeepConnectionAlive = true;
                context.BeginTransaction();

                decimal?[] fsValues = GetFSValues(columnNo);
                CompanyFinancialStatement cfs = FinancialServices.Instance.GetCreateCompanyFinancialStatement(context, this.CompanyID, this.ForYear,
                                   this.FiscalPeriod, this.ArgaamSectorTemplateID, this.UpdateUserID, fsValues);

                foreach (FSTemplateFieldListEntity fld in this.FSOrderedTemplateFields)
                {
                    if (fld.ExcelTemplateRow == 0)
                    {
                        continue;
                    }
                    decimal? fSFieldFinalValue = null;

                    bool isDbNull = false;
                    string fsValue = "";
                    var exRow = ExcelData.Rows[fld.ExcelTemplateRow - 2][columnNo];
                    if (exRow == DBNull.Value)
                    {
                        isDbNull = true;
                    }
                    else
                    {
                        fsValue = ((string)exRow).Trim();
                        if (fsValue.ToUpper() == "NA")
                        {
                            isDbNull = true;
                        }
                    }
                    if (!isDbNull)
                    {
                        if (fsValue.Contains("%"))
                        {
                            fsValue = fsValue.Replace("%", "");
                        }
                        bool isNegativeVal = false;
                        if (fsValue.Contains('('))
                        {
                            isNegativeVal = true;
                            fsValue = fsValue.Trim('(', ')', ' ');
                        }

                        decimal fSFieldValue = 0;
                        decimal.TryParse(fsValue, out fSFieldValue);

                        if (isNegativeVal)
                        {
                            fSFieldValue = fSFieldValue * -1;
                        }
                        fSFieldFinalValue = fSFieldValue;
                    }
                    FinancialServices.Instance.updateCompanyFinancialStatementValue(context, cfs.CompanyFinancialStatementID, fld.FSTemplateFieldID, fSFieldFinalValue);

                }

                context.CompleteTransaction();
                retVal = true;
            }
            return retVal;
        }

        public decimal?[] GetFSValues(int columnNo)
        {
            decimal?[] fsValues = new decimal?[FSOrderedTemplateFields.Count];
            int count = 0;
            foreach (FSTemplateFieldListEntity fld in this.FSOrderedTemplateFields)
            {
                if (fld.ExcelTemplateRow == 0)
                {
                    continue;
                }
                decimal? fSFieldFinalValue = null;

                bool isDbNull = false;
                string fsValue = "";
                var exRow = ExcelData.Rows[fld.ExcelTemplateRow - 2][columnNo];
                if (exRow == DBNull.Value)
                {
                    isDbNull = true;
                }
                else
                {
                    fsValue = ((string)exRow).Trim();
                    if (fsValue.ToUpper() == "NA")
                    {
                        isDbNull = true;
                    }
                }
                if (!isDbNull)
                {
                    if (fsValue.Contains("%"))
                    {
                        fsValue = fsValue.Replace("%", "");
                    }
                    bool isNegativeVal = false;
                    if (fsValue.Contains('('))
                    {
                        isNegativeVal = true;
                        fsValue = fsValue.Trim('(', ')', ' ');
                    }

                    decimal fSFieldValue = 0;
                    decimal.TryParse(fsValue, out fSFieldValue);

                    if (isNegativeVal)
                    {
                        fSFieldValue = fSFieldValue * -1;
                    }
                    fSFieldFinalValue = fSFieldValue;
                }
                fsValues[count] = fSFieldFinalValue;
                count++;
            }
            return fsValues;
        }


    }
}