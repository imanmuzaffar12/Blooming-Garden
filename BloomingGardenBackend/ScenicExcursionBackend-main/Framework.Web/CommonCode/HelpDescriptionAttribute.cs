using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Adoofy.CommonCode
{
    public class HelpDescriptionAttribute : Attribute
    {
        public HelpDescriptionAttribute()
        {
            this.Updated = false;
        }
        public HelpDescriptionAttribute(Type actualreturnType, bool isReturnTypeIsList, string urlFriendlyName)
        {
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.UrlFriendlyName = urlFriendlyName;
        }
        public HelpDescriptionAttribute(Type actualreturnType, bool isReturnTypeIsList, string urlFriendlyName, string headers, string requestType)
        {
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.UrlFriendlyName = urlFriendlyName;
            this.Headers = headers;
            this.RequestType = requestType;
        }
        public HelpDescriptionAttribute(Type actualreturnType, bool isReturnTypeIsList, string urlFriendlyName, string formFields)
        {
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.UrlFriendlyName = urlFriendlyName;
            this.FormFields = formFields.Split(",".ToCharArray());
        }
        public HelpDescriptionAttribute(Type actualreturnType, bool isReturnTypeIsList, string urlFriendlyName, string formFields, string headers, string requestType)
        {
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.UrlFriendlyName = urlFriendlyName;
            this.FormFields = formFields.Split(",".ToCharArray());
            this.Headers = headers;
            this.RequestType = requestType;
        }
        public HelpDescriptionAttribute(string description, Type actualreturnType, bool isReturnTypeIsList, string urlFriendlyName)
        {
            this.Description = description;
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.UrlFriendlyName = urlFriendlyName;
        }

        public HelpDescriptionAttribute(string description, Type actualreturnType, bool isReturnTypeIsList, string formFields, string urlFriendlyName)
        {
            this.Description = description;
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.FormFields = formFields.Split(",".ToCharArray());
            this.UrlFriendlyName = urlFriendlyName;
        }
        public HelpDescriptionAttribute(string description, Type actualreturnType, bool isReturnTypeIsList, string[] formFields, APIType apitype, string urlFriendlyName)
        {
            this.Description = description;
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.FormFields = formFields;
            this.ApiType = apitype;
            this.UrlFriendlyName = urlFriendlyName;
        }
        public HelpDescriptionAttribute(string description, Type actualreturnType, bool isReturnTypeIsList, string[] formFields, APIType apitype, string urlFriendlyName, bool updated)
        {
            this.Description = description;
            this.ActualReturnType = actualreturnType;
            this.IsReturnTypeIsList = isReturnTypeIsList;
            this.FormFields = formFields;
            this.ApiType = apitype;
            this.UrlFriendlyName = urlFriendlyName;
            this.Updated = updated;
        }

        public string Description { get; set; }
        public Type ActualReturnType { get; set; }
        public bool IsReturnTypeIsList { get; set; }
        public string[] FormFields { get; set; }
        public APIType ApiType { get; set; }
        public string UrlFriendlyName { get; set; }
        /// <summary>
        /// Updated from Last version?
        /// </summary>
        public bool Updated { get; set; }
        public bool IsNew { get; set; }
        public string Headers { get; set; }
        public string RequestType { get; set; }
    }

    public enum APIType
    {
        Post,
        Get
    }
}