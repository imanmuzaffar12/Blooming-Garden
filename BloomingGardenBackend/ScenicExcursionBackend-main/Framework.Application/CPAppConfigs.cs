using Framework.Shared.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Basketo.Application
{
    public static class CPAppConfigs
    {
       
        public static List<int> MarketIdsToShowDataFor
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<List<int>>("CP_MARKET_IDS_TO_SHOW_DATA_FOR"));
            }
        }

        public static int CompanyListRecordsPerPage
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("CP_COMPANY_LIST_RECORDS_PER_PAGE"));
            }
        }

        public static int YearMaxValue
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("CP_YEAR_MAXVALUE"));
            }
        }

        public static int YearMinValue
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("CP_YEAR_MINVALUE"));
            }
        }

        public static string ControlPanelURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_CONTROL_PANEL_URL"));
            }
        }
        public static string GetConfigValue(string key)
        {
            return AppConfigHelper.GetConfigValue<string>(key);
        }

    }
}
