using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Framework.Web.CommonCode.Helpers
{
    public class TemplateBrowser
    {
        public int TotalRows = -1;
        public int CurrentRow = -1;

        public string Template = string.Empty;
        public MatchCollection Storage = null;
        public IEnumerator Iterator = null;

        private static Regex startMarkup = new Regex(@"^\[\$starttemplate\]\[\$startmarkup\](?<html>[^\$]+)\[\$endmarkup\]", RegexOptions.Compiled);
        private static Regex endMarkup = new Regex(@"\[\$startmarkup\](?<html>[^\$]+)\[\$endmarkup\]\[\$endtemplate\]$", RegexOptions.Compiled);
        private static Regex row = new Regex(@"\[\$startrow\](?<html>[^\$]+)\[\$endrow\]", RegexOptions.Compiled);

        public string TemplateStart()
        {
            return startMarkup.Match(Template).Groups["html"].Value;
        }

        public string TemplateEnd()
        {
            return endMarkup.Match(Template).Groups["html"].Value;
        }

        public string ReturnTemplateRow()
        {
            if (!Iterator.MoveNext()) { CurrentRow = 0; Iterator.Reset(); Iterator.MoveNext(); }
            CurrentRow++;
            return ((Match)Iterator.Current).Groups["html"].Value;
        }

        public void SetTemplate(string template)
        {
            if (template.Length == 0) return;

            Storage = row.Matches(template);
            if (Storage.Count == 0) return;

            Template = template;
            TotalRows = Storage.Count;
            CurrentRow = 0;
            Iterator = Storage.GetEnumerator();

        }
    }
}