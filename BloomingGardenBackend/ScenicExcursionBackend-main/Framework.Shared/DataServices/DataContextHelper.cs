
using Framework.Shared.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Framework.Shared.DataServices
{
    public static class DataContextHelper
    {
        public static FrameworkRepository GetExceptionLoggingDataContext(bool enableAutoSelect = false)
        {
            return (GetNewDataContext("ELConnectionString", enableAutoSelect));
        }

        public static FrameworkRepository GetBackgroundProcessDataContext(ELHelper elHelperInstance = null, bool enableAutoSelect = false)
        {
            return (GetNewDataContext("BGSConnectionString", enableAutoSelect, elHelperInstance));
        }

        public static FrameworkRepository GetPPDataContext(ELHelper elHelperInstance, bool enableAutoSelect = true)
        {
            return (GetNewDataContext("PPConnectionString", enableAutoSelect, elHelperInstance));
        }

        public static FrameworkRepository GetPPDataContext(bool enableAutoSelect = true)
        {
            return (GetPPDataContext(null, enableAutoSelect));
        }

        public static FrameworkRepository GetCPDataContext(ELHelper elHelperInstance, bool enableAutoSelect = true)
        {
            return (GetNewDataContext("CPConnectionString", enableAutoSelect, elHelperInstance));
        }

        public static FrameworkRepository GetCPDataContext(bool enableAutoSelect = true)
        {
            return (GetCPDataContext(null, enableAutoSelect));
        }

        private static FrameworkRepository GetNewDataContext(string connectionStringName, bool enableAutoSelect, ELHelper elHelperInstance = null)
        {
            FrameworkRepository repository = new FrameworkRepository(connectionStringName);
            repository.EnableAutoSelect = enableAutoSelect;
            repository.ELHelperInstance = elHelperInstance;
            return (repository);
        }
    }
}
