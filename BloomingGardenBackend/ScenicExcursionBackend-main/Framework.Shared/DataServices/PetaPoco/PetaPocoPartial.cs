using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;

namespace PetaPoco
{
    public partial class Database : IDisposable
    {
        #region operation Fill
        public void Fill(DataSet ds, Sql sql)
        {
            OpenSharedConnection();
            try
            {
                using (var cmd = CreateCommand(_sharedConnection, sql.SQL, sql.Arguments))
                {
                    using (DbDataAdapter dbDataAdapter = _factory.CreateDataAdapter())
                    {
                        dbDataAdapter.SelectCommand = (DbCommand)cmd; dbDataAdapter.Fill(ds);
                    }
                }
            }
            finally
            {
                CloseSharedConnection();
            }
        }
        public void Fill(DataTable dt, Sql sql)
        {
            OpenSharedConnection();
            try
            {
                using (var cmd = CreateCommand(_sharedConnection, sql.SQL, sql.Arguments))
                {
                    using (DbDataAdapter dbDataAdapter = _factory.CreateDataAdapter())
                    {
                        dbDataAdapter.SelectCommand = (DbCommand)cmd;
                        dbDataAdapter.Fill(dt);
                    }
                }
            }
            finally
            {
                CloseSharedConnection();
            }
        }
        #endregion Operation fill end
    }
}
