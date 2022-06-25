using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;


namespace Framework.Web.CommonCode.Helpers
{
    public static class CommonHelper
    {
        public static int getRandomNumber()
        {
            Random random = new Random((int)(DateTime.Now.Ticks % 1000000));
            int MyRandomNumber = random.Next(1, 1000000);
            return MyRandomNumber;
        }

        public static bool IsCastableTo(this Type from, Type to)
        {
            if (to.IsAssignableFrom(from))
            {
                return true;
            }
            var methods = from.GetMethods(BindingFlags.Public | BindingFlags.Static)
                              .Where(
                                  m => m.ReturnType == to &&
                                       (m.Name == "op_Implicit" ||
                                        m.Name == "op_Explicit")
                              );
            return methods.Count() > 0;
        }

        public static string GetArgaamFetchArticleAPIUrl
        {
            get { return ConfigurationManager.AppSettings["FetchArgaamArticleUrl"].ToString(); }
        }
        public static string GetArgaamFetchArticleRelatedDetailAPIUrl
        {
            get { return ConfigurationManager.AppSettings["FetchArgaamArticleRelatedDetailUrl"].ToString(); }
        }

        public static string GetOptionalDateStr(short? dd, short? mm, short? yy)
        {
            string retVal = "";
            if (dd != null)
            {
                retVal = dd.ToString();
            }
            if (mm != null)
            {
                if (retVal != "")
                {
                    retVal = retVal + "/";
                }
                retVal = retVal + mm.ToString();
            }
            if (yy != null)
            {
                if (retVal != "")
                {
                    retVal = retVal + "/";
                }
                retVal = retVal + yy.ToString();
            }
            if (retVal == "")
            {
                retVal = "-";
            }
            return retVal;
        }
    }
}



