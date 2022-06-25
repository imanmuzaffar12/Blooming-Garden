using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Framework.Shared.Helpers
{
    public static class GlobalAppConfigs
    {
        #region REDIS Settings

        public static bool UseRedis
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<bool>("G_USE_REDIS"));
            }
        }

        public static string RedisPassword
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_REDIS_PASSWORD"));
            }
        }

        public static int RedisConnectionPoolSize
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("G_REDIS_CONN_POOL_SIZE"));
            }
        }

        public static string RedisServerIP
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_REDIS_SERVER_IP"));
            }
        }

        public static int RedisServerPort
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("G_REDIS_SERVER_PORT"));
            }
        }

        public static int RedisDbID
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("G_REDIS_DB_ID"));
            }
        }

        #endregion

        public static string RESTAPIURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_RESTAPI_URL"));
            }
        }

        // TODO: Fix this
        public static bool UseCachedData
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<bool>("G_USE_CACHED_DATA"));
            }
        }

        public static bool UseDataAPI
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<bool>("G_USE_RESTAPI"));
            }
        }

        public static short DefaultMarketID
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<short>("G_DEFAULT_MARKET_ID"));
            }
        }

        public static string PublicPortalURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_PUBLIC_PORTAL_URL"));
            }
        }

        public static string PublicPortalArticleDetailURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_ARTICLE_DETAIL_URL"));
            }
        }

        public static string NewsListingURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_NEWSLISTING_URL"));
            }
        }

        public static int SaudiTime
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<int>("G_SAUDI_TIME"));
            }
        }

        public static string Default_GeoLocation_Latitude
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("DEFAULT_GEOLOCATION_LATITUDE"));
            }
        }

        public static string Default_GeoLocation_Longitude
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("DEFAULT_GEOLOCATION_LONGITUDE"));
            }
        }

        public static string EmailTemplatorURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_EMAIL_TEMPLATOR_URL"));
            }
        }

        public static string ControlPanelURL
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<string>("G_CONTROL_PANEL_URL"));
            }
        }

        public static short CPDeveloperRoleID
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<short>("G_CP_ROLE_DEVELOPER_ID"));
            }
        }
        public static bool EnableRoleRights
        {
            get
            {
                return (AppConfigHelper.GetConfigValue<bool>("EnableRoleRights"));
            }
        }
    }
}
