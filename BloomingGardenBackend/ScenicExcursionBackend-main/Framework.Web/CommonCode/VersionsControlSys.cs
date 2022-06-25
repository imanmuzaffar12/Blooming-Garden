using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Adoofy.CommonCode
{
    public class VersionsControlSys
    {
        public static Dictionary<string, string> VersionDictionary
        {
            get
            {
                Dictionary<string, string> dic = new Dictionary<string, string>();
                dic.Add("v1", "Mobile10");
                return dic;
            } 
        }

        public static Dictionary<string, object> VersionDictionaryWithObject
        {
            get
            {
                Dictionary<string, object> dic = new Dictionary<string, object>();
                dic.Add("v1", new VersionObject() { Version = "v1", Controller = new Framework.Areas.V1.Controllers.APIController(), SupportURLRouting = true });
                return dic;
            }
        }

        public class VersionObject
        {
            public string Version { get; set; }
            public bool SupportURLRouting { get; set; }
            public System.Web.Mvc.Controller Controller { get; set; }
        }
    }
}