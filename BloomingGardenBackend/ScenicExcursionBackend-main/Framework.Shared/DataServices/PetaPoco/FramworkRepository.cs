using Framework.Shared.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Framework.Shared.DataServices
{
    public partial class FrameworkRepository
    {
        public override void OnExecutingCommand(System.Data.IDbCommand cmd)
        {
            if (System.Configuration.ConfigurationManager.AppSettings["LOG_PETAPOCO_SQLS"] != null
                && System.Configuration.ConfigurationManager.AppSettings["LOG_PETAPOCO_SQLS"] == "true")
            {
                LogSql(cmd);
            }

            base.OnExecutingCommand(cmd);
        }

        public string LastExecutedSql { get; set; }
        public ELHelper ELHelperInstance { get; set; }

        void LogSql(IDbCommand sqlCmd)
        {
            try
            {
                System.Data.SqlClient.SqlCommand sqlCommand = (System.Data.SqlClient.SqlCommand)sqlCmd;

                using (System.Data.SqlClient.SqlConnection dbConn = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["BGSConnectionString"].ConnectionString))
                {
                    dbConn.Open();

                    System.Data.SqlClient.SqlCommand dbCmd = dbConn.CreateCommand();
                    dbCmd.CommandType = CommandType.Text;
                    dbCmd.CommandText = "INSERT INTO AppSqlLogs (ExecutingSql, ExecutedOn, HostMachine) VALUES (@sqlText, @occuredOn, @hostMachine)";
                    StringBuilder sb = new StringBuilder(sqlCommand.CommandText);
                    for (int i = 0; i < sqlCommand.Parameters.Count; i++)
                    {
                        switch (sqlCommand.Parameters[i].SqlDbType)
                        {
                            case SqlDbType.BigInt:
                            case SqlDbType.Int:
                            case SqlDbType.SmallInt:
                            case SqlDbType.TinyInt:
                                sb.Replace("@" + i, sqlCommand.Parameters[i].Value.ToString());
                                break;
                            case SqlDbType.DateTime:
                            case SqlDbType.DateTime2:
                            case SqlDbType.NVarChar:
                            case SqlDbType.VarChar:
                                sb.Replace("@" + i, "'" + sqlCommand.Parameters[i].Value.ToString() + "'");
                                break;
                        }
                    }
                    LastExecutedSql = sb.ToString();
                    if (ELHelperInstance != null)
                    {
                        ELHelperInstance.AddLastExecutedSql(LastExecutedSql);
                    }
                    dbCmd.Parameters.Add("@sqlText", SqlDbType.NVarChar, 2048).Value = LastExecutedSql;
                    dbCmd.Parameters.Add("@occuredOn", SqlDbType.DateTime2).Value = DateTime.Now;
                    dbCmd.Parameters.Add("@hostMachine", SqlDbType.VarChar, 64).Value = System.Environment.MachineName;

                    dbCmd.ExecuteNonQuery();
                }
            }
            catch
            {
#if DEBUG
                System.Diagnostics.Debugger.Break();
#endif
            }
        }
    }
}
