using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

using Framework.Shared.DataServices;

namespace Framework.Shared.Helpers
{
    public class AppConfigHelper
    {
        public static T GetConfigValue<T>(string configKey)
        {
            ELHelper elh = new ELHelper();

            T result = default(T);

            try
            {
                return (AppConfigHelper.GetConfigValueFromLocalConfigFile<T>(configKey));
            }
            catch// (Exception ex)
            {
                // Config not found in local config file
            }

            // TODO: Adnan, Check Redis

            using (FrameworkRepository db = DataContextHelper.GetBackgroundProcessDataContext(elh, true))
            {
                AppConfig ac = null;

                PetaPoco.Sql pSql = PetaPoco.Sql.Builder.From("AppConfigs")
                    .Where("AppConfigKey = @0", configKey);

                try
                {
                    elh.AddVariable(() => configKey);

                    ac = db.Single<AppConfig>(pSql);
                }
                catch (Exception ex)
                {
                    ApplicationException ae = new ApplicationException("No such configuration key found: " + configKey, ex);
                    elh.LogException(ae);
                    throw (ae);
                }

                result = (T)ConvertValueToProperTypes<T>(ac.AppConfigValue);
            }

            return (result);
        }

        private static T GetConfigValueFromLocalConfigFile<T>(string configKey)
        {
            T result = default(T);

            if (System.Configuration.ConfigurationManager.AppSettings[configKey] != null)
            {
                result = (T)ConvertValueToProperTypes<T>(ConfigurationManager.AppSettings[configKey]);
            }
            else
            {
                throw (new KeyNotFoundException(configKey));
            }

            return (result);
        }

        private static object ConvertValueToProperTypes<T>(string configValue)
        {
            object result = configValue;

            if (typeof(T) == typeof(int))
            {
                result = int.Parse(configValue);
            }
            else if (typeof(T) == typeof(short))
            {
                result = short.Parse(configValue);
            }
            else if (typeof(T) == typeof(decimal))
            {
                result = decimal.Parse(configValue);
            }
            else if (typeof(T) == typeof(bool))
            {
                result = bool.Parse(configValue);
            }
            else
            {
                string[] strValues = configValue.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                if (typeof(T) == typeof(List<int>))
                {
                    List<int> values = new List<int>();

                    foreach (string s in strValues)
                    {
                        values.Add(int.Parse(s));
                    }

                    result = values;
                }
                else if (typeof(T) == typeof(int[]))
                {
                    int[] values = new int[strValues.Count()];
                    int index = 0;

                    foreach (string s in strValues)
                    {
                        values[index++] = int.Parse(s);
                    }

                    result = values;
                }
                else if (typeof(T) == typeof(List<decimal>))
                {
                    List<decimal> values = new List<decimal>();

                    foreach (string s in strValues)
                    {
                        values.Add(decimal.Parse(s));
                    }

                    result = values;
                }
                else if (typeof(T) == typeof(decimal[]))
                {
                    decimal[] values = new decimal[strValues.Count()];
                    int index = 0;

                    foreach (string s in strValues)
                    {
                        values[index++] = decimal.Parse(s);
                    }

                    result = values;
                }
                else if (typeof(T) == typeof(List<string>))
                {
                    result = new List<string>(strValues);
                }
                else if (typeof(T) == typeof(string[]))
                {
                    result = configValue.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                }
            }

            return (result);
        }
    }
}
