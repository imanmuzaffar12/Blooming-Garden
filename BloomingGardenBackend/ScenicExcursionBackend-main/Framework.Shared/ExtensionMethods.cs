using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

//namespace Basketo.Shared
//{
public static class ExtensionMethods
{
    /// <summary>
    /// Compiled regular expression for performance.
    /// </summary>
    static Regex _htmlRegex = new Regex("<.*?>", RegexOptions.Compiled);

    //TODO: Get/Set fro DB configuration 
    static string DateTimeFormatForNumericConversion = "yyyyMMddHHmmss";

    #region String Extensions
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sTitle"></param>
    /// <returns></returns>
    public static string FixUnidirectionalText(this string sTitle)
    {
        char rle = (char)8235, pdf = (char)8236;
        sTitle = string.Format("{0}{1}{2}", rle, sTitle, pdf);//issue# 0002481
        sTitle = sTitle.Trim();
        RemoveLTRCharacters(ref sTitle);//Remove LTR Characters
        return sTitle;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="arg"></param>
    private static void RemoveLTRCharacters(ref string arg)
    {
        while (arg.IndexOfAny(new char[] { (char)8206 }) > -1)
        {
            int i = arg.IndexOfAny(new char[] { (char)8206 });
            arg = arg.Remove(i, 1);
        }
    }

    //TODO: Modify this method to check size of string before converting to ellipsis
    /// <summary>
    /// 
    /// </summary>
    /// <param name="textToTrim"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static string TrimToSizeWithEllipsis(this string textToTrim, int size)
    {
        return string.Format("{0}...", textToTrim.TrimToSize(size));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="textToTrim"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static string TrimToSize(this string textToTrim, int size)
    {
        if (string.IsNullOrEmpty(textToTrim))
        {
            return textToTrim;
        }
        else
        {
            textToTrim = textToTrim.Trim();

            if (textToTrim.Length <= size)
                return textToTrim;
            if ((textToTrim.Length - 1) > size)
            {
                textToTrim = textToTrim.Substring(0, (textToTrim.IndexOf(" ", size) == -1) ? size : textToTrim.IndexOf(" ", size));
            }

            return textToTrim;
        }
    }

    private static string illegalCharacterReplacePattern = @"[^\w]";

    public static string SanitizeString(this string str)
    {
        string sanitizedString = string.Empty;

        sanitizedString = Regex.Replace(str.Trim(), illegalCharacterReplacePattern, "-");
        sanitizedString = sanitizedString.Replace("---", "-").Replace("--", "-");
        sanitizedString = sanitizedString.TrimStart('-').TrimEnd('-');

        return sanitizedString;
    }

    public static string SeparatedString(this string separator, int[] source)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < source.Length; i++)
        {
            sb.Append(source[i]);
            if (i + 1 < source.Length)
            {
                sb.Append(separator);
            }
        }
        return sb.ToString();
    }

    public static string IfNullShowAlternative(this string str, string alternativeStr)
    {
        if (string.IsNullOrWhiteSpace(str))
        {
            return alternativeStr;
        }
        else
        {
            return str;
        }
    }

    public static string StripHtmlTagsRegex(this string source)
    {
        return Regex.Replace(source, "<.*?>", string.Empty);
    }

    /// <summary>
    /// Remove HTML from string with compiled Regex.
    /// </summary>
    public static string StripHtmlTagsRegexCompiled(this string source)
    {
        return _htmlRegex.Replace(source, string.Empty);
    }

    /// <summary>
    /// Remove HTML tags from string using char array.
    /// </summary>
    public static string StripHtmlTagsCharArray(this string source)
    {
        if (string.IsNullOrEmpty(source))
        {
            return string.Empty;
        }
        char[] array = new char[source.Length];
        int arrayIndex = 0;
        bool inside = false;

        for (int i = 0; i < source.Length; i++)
        {
            char let = source[i];
            if (let == '<')
            {
                inside = true;
                continue;
            }
            if (let == '>')
            {
                inside = false;
                continue;
            }
            if (!inside)
            {
                array[arrayIndex] = let;
                arrayIndex++;
            }
        }

        return new string(array, 0, arrayIndex);
    }
    #endregion String methods

    #region Request Extensions
    public static string GetClientIPAddress(this HttpRequestBase request)
    {
        string strIp = string.Empty;
        strIp = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

        LoggingServices.WriteDebug("HTTP_X_FORWARDED_FOR: " + strIp);

        if (string.IsNullOrEmpty(strIp))
        {
            strIp = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            LoggingServices.WriteDebug("REMOTE_ADDR: " + strIp);
        }
        else
        {
            string[] strIpArray = strIp.Split(new char[] { ',' });
            strIp = strIpArray[0];
        }

        return strIp;
    }

    public static string GetMyIP(this HttpRequestBase request)
    {
        string host = Dns.GetHostName();
        IPHostEntry ip = Dns.GetHostEntry(host);

        return ip.AddressList[1].ToString();
    }
    #endregion Request Methods

    #region Response Extensions
    /// <summary>
    /// 
    /// </summary>
    /// <param name="response"></param>
    /// <param name="location"></param>
    public static void RedirectWithoutEncodingURL(this HttpResponseBase response, string location)
    {
        if (HttpContext.Current.Request.Browser.Browser.ToLower().Equals("ie") && (HttpContext.Current.Request.Browser.MajorVersion == 6))
        {
            response.RedirectPermanent(location);
        }
        else
        {
            response.Clear();
            response.StatusCode = 307;
            response.Status = "307 Temporary Redirect";
            response.AddHeader("Location", location);
            response.End();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="response"></param>
    /// <param name="location"></param>
    public static void RedirectPermanentWithoutEncodingURL(this HttpResponseBase response, string location)
    {
        if (HttpContext.Current.Request.Browser.Browser.ToLower().Equals("ie") && (HttpContext.Current.Request.Browser.MajorVersion == 6))
        {
            response.RedirectPermanent(location);
        }
        else
        {
            response.Clear();
            response.StatusCode = 301;
            response.Status = "301 Moved Permanently";
            response.AddHeader("Location", location);
            response.End();
        }
    }
    #endregion Response Methods

    /// <summary>
    /// To fetch data from namevaluecollection (e.g. querystring)
    /// </summary>
    /// <param name="queryString"></param>
    /// <param name="key"></param>
    /// <returns></returns>

    //public static string GetValue(this NameValueCollection nvc, string key)
    //{
    //    string value = null;
    //    for (var i = 0; i < nvc.Keys.Count; i++)
    //    {
    //        var idKey = nvc.Keys[i];
    //        if (null != idKey && idKey.ToLower() == key.ToLower())
    //        {
    //            value = nvc[i];
    //            break;
    //        }
    //    }

    //    return value;
    //}

    /// <summary>
    /// This will return a string with number and % sign, if the number is Negative it will return (23.23 %) 
    /// </summary>
    /// <param name="decimalNumber"></param>
    /// <returns></returns>
    public static string Percent(this decimal decimalNumber)
    {
        return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", decimalNumber / 100.0M);
    }
    /// <summary>
    /// This will return a string with number and % sign, if the number is Negative it will return (23.23 %) 
    /// </summary>
    /// <param name="decimalNumber"></param>
    /// <returns></returns>
    public static string Percent(this float floatNumber)
    {
        return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", floatNumber / 100.0);
    }
    /// <summary>
    /// This will return a string with number and % sign, if the number is Negative it will return (23.23 %) 
    /// </summary>
    /// <param name="decimalNumber"></param>
    /// <returns></returns>
    public static string Percent(this double doubleNumber)
    {
        return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", doubleNumber / 100.0D);
    }
    public static string Percent(this double? doubleNumber)
    {
        if (doubleNumber.HasValue)
            return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", doubleNumber.Value / 100.0D);
        else
            return "";
    }

    public static string Percent(this decimal? decimalNumber)
    {
        if (decimalNumber.HasValue)
            return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", decimalNumber.Value / 100.0M);
        else
            return "";
    }

    public static string ProperPercent(this decimal? decimalNumber)
    {
        if (decimalNumber.HasValue)
            return string.Format("{0:#,#0.00 %;(#0.00 %);0.00 %}", decimalNumber.Value / 100.0M);
        else
            return "-";
    }

    /// <summary>
    /// It works like group by a single property value
    /// </summary>
    /// <typeparam name="tSource"></typeparam>
    /// <typeparam name="tKey"></typeparam>
    /// <param name="src"></param>
    /// <param name="keySelecta"></param>
    /// <returns></returns>
    public static IEnumerable<tSource> UniqueBy<tSource, tKey>(this IEnumerable<tSource> src, Func<tSource, tKey> keySelecta)
    {
        HashSet<tKey> res = new HashSet<tKey>();
        foreach (tSource e in src)
        {
            tKey k = keySelecta(e);
            if (res.Contains(k))
                continue;
            res.Add(k);
            yield return e;
        }
    }

    private const string KEY = "ARG@PLIS";
    private const string IV = "HUN@IDIS";

    public static string Decrypt(this string encText)
    {
        if (encText.Trim().Length == 0)
            return string.Empty;
        byte[] bKey, bIV, bInput;

        bKey = System.Text.Encoding.UTF8.GetBytes(KEY);
        bIV = System.Text.Encoding.UTF8.GetBytes(IV);
        bInput = Convert.FromBase64String(encText);

        MemoryStream memStream = new MemoryStream();

        DES des = new DESCryptoServiceProvider();
        CryptoStream encStream = new CryptoStream(memStream, des.CreateDecryptor(bKey, bIV), CryptoStreamMode.Write);

        encStream.Write(bInput, 0, bInput.Length);
        encStream.FlushFinalBlock();

        return (System.Text.Encoding.UTF8.GetString(memStream.ToArray()));
    }

    public static string Encrypt(this string text)
    {
        if (text.Trim().Length == 0)
            return string.Empty;
        byte[] bKey, bIV, bInput;

        bKey = System.Text.Encoding.UTF8.GetBytes(KEY);
        bIV = System.Text.Encoding.UTF8.GetBytes(IV);
        bInput = System.Text.Encoding.UTF8.GetBytes(text);

        MemoryStream memStream = new MemoryStream();

        DES des = new DESCryptoServiceProvider();
        CryptoStream encStream = new CryptoStream(memStream, des.CreateEncryptor(bKey, bIV), CryptoStreamMode.Write);

        encStream.Write(bInput, 0, bInput.Length);
        encStream.FlushFinalBlock();
        string st = Convert.ToBase64String(memStream.ToArray());

        return (st);
    }

    public static string ToMD5Hash(this string input)
    {
        // step 1, calculate MD5 hash from input
        MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
        byte[] hash = md5.ComputeHash(inputBytes);

        // step 2, convert byte array to hex string
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < hash.Length; i++)
        {
            sb.Append(hash[i].ToString("X2"));
        }
        return sb.ToString();
    }

    public static void AddOrUpdate<TKey, TValue>(this Dictionary<TKey, TValue> dict, TKey key, TValue value)
    {
        if (dict.ContainsKey(key))
        {
            dict[key] = value;
        }
        else
        {
            dict.Add(key, value);
        }
    }

    public static DateTime? ConvertLongToDateTime(this long? dateTimeNumericValue)
    {
        DateTime? returnValue = null;

        if (dateTimeNumericValue.HasValue)
        {
            returnValue = DateTime.ParseExact(dateTimeNumericValue.ToString(), DateTimeFormatForNumericConversion, CultureInfo.InvariantCulture); //Convert.ToDateTime(dd.ToString().Insert(4, "/").Insert(7, "/").Insert(10, " ").Insert(13, ":").Insert(16, ":"));
        }

        return returnValue;
    }

    public static long ConvertDateTimeToLong(this DateTime dateTimeValue)
    {
        return Convert.ToInt64(dateTimeValue.ToString(DateTimeFormatForNumericConversion));
    }

    /// <summary>
    /// This Extenssion method will convert an english string to first characters to Upper case
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string Wordify(this string value)
    {
        char[] array = value.ToCharArray();
        // Handle the first letter in the string.
        if (array.Length >= 1)
        {
            if (char.IsLower(array[0]))
            {
                array[0] = char.ToUpper(array[0]);
            }
        }
        // Scan through the letters, checking for spaces.
        // ... Uppercase the lowercase letters following spaces.
        for (int i = 1; i < array.Length; i++)
        {
            if (array[i - 1] == ' ')
            {
                if (char.IsLower(array[i]))
                {
                    array[i] = char.ToUpper(array[i]);
                }
            }
        }
        return new string(array);
    }
    public static string Singlofy(this string value)
    {
        return MakeSingular(value);

    }
    public static string Sentencify(this string value)
    {
        if(string.IsNullOrEmpty(value))
            return value;
        return ToTitleCase(value);
    }
    public static string Decimal(this decimal? decimalNumber)
    {
        if (decimalNumber.HasValue)
            return string.Format("{0:#,#0.00}", decimalNumber.Value);
        else
            return "";
    }
    public static string Decimal(this decimal decimalNumber)
    {
        return string.Format("{0:#,#0.00}", decimalNumber);
    }
    public static string TwoDecimalPlace(this decimal decimalNumber)
    {
        return string.Format("{0:##0.00}", decimalNumber);
    }
    public static string ReverseString(this string value)
    {
        char[] arr = value.ToCharArray();
        Array.Reverse(arr);
        return new string(arr);
    }
    public static string Double(this double doubleNumber)
    {
        return string.Format("{0:#,#0.00}", doubleNumber);
    }
    public static string Decimal4Digits(this decimal? decimalNumber)
    {
        if (decimalNumber.HasValue)
            return string.Format("{0:#,#0.0000}", decimalNumber.Value);
        else
            return "";
    }
    public static string Proper4Digits(this string decimalNumber)
    {
        if (!string.IsNullOrEmpty(decimalNumber))
            if (decimal.Parse(decimalNumber) < 0)
                return string.Format("{0:#,#0.0000})", decimalNumber.Replace("-", "("));
            else if (decimalNumber == "0.0000")
                return "-";
            else
                return string.Format("{0:#,#0.0000}", decimalNumber);
        else
            return "-";
    }
    public static string Proper(this string decimalNumber)
    {
        if (!string.IsNullOrEmpty(decimalNumber))
            if (decimal.Parse(decimalNumber) < 0)
                return string.Format("{0:#,#0.00})", decimalNumber.Replace("-", "("));
            else
                return string.Format("{0:#,#0.00}", decimalNumber);
        else
            return "-";
    }
    public static string FormatProper(this string decimalNumber)
    {
        if (!string.IsNullOrEmpty(decimalNumber))
            if (decimal.Parse(decimalNumber) < 0)
                return string.Format("{0:#,#0.00})", decimalNumber.Replace("-", "("));
            else
                return string.Format("{0:#,#0.00}", decimalNumber);
        else
            return "-";
    }
    public static string ProperWithZero(this string decimalNumber)
    {
        if (!string.IsNullOrEmpty(decimalNumber))
            if (decimal.Parse(decimalNumber) < 0)
                return string.Format("{0:#,#0.00})", decimalNumber.Replace("-", "("));
            else if (decimalNumber == "0.00")
                return "0.00";
            else if (decimal.Parse(decimalNumber) > 0)
                return string.Format("{0:#,#0.00}", decimal.Parse(decimalNumber));
            else
                return string.Format("{0:#,#0.00}", decimal.Parse(decimalNumber));
        else
            return "-";
    }
    public static Type GetCoreType(this Type type)
    {
        if (type.IsGenericType &&
            type.GetGenericTypeDefinition() == typeof(Nullable<>))
            return Nullable.GetUnderlyingType(type);
        else
            return type;
    }
 
    #region Singular and Plural
    private static readonly List<InflectorRule> _plurals = new List<InflectorRule>();
    private static readonly List<InflectorRule> _singulars = new List<InflectorRule>();
    private static readonly List<string> _uncountables = new List<string>();
    static ExtensionMethods()
    {
        AddPluralRule("$", "s");
        AddPluralRule("s$", "s");
        AddPluralRule("(ax|test)is$", "$1es");
        AddPluralRule("(octop|vir)us$", "$1i");
        AddPluralRule("(alias|status)$", "$1es");
        AddPluralRule("(bu)s$", "$1ses");
        AddPluralRule("(buffal|tomat)o$", "$1oes");
        AddPluralRule("([ti])um$", "$1a");
        AddPluralRule("sis$", "ses");
        AddPluralRule("(?:([^f])fe|([lr])f)$", "$1$2ves");
        AddPluralRule("(hive)$", "$1s");
        AddPluralRule("([^aeiouy]|qu)y$", "$1ies");
        AddPluralRule("(x|ch|ss|sh)$", "$1es");
        AddPluralRule("(matr|vert|ind)ix|ex$", "$1ices");
        AddPluralRule("([m|l])ouse$", "$1ice");
        AddPluralRule("^(ox)$", "$1en");
        AddPluralRule("(quiz)$", "$1zes");

        AddSingularRule("s$", String.Empty);
        AddSingularRule("ss$", "ss");
        AddSingularRule("(n)ews$", "$1ews");
        AddSingularRule("([ti])a$", "$1um");
        AddSingularRule("((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$", "$1$2sis");
        AddSingularRule("(^analy)ses$", "$1sis");
        AddSingularRule("([^f])ves$", "$1fe");
        AddSingularRule("(hive)s$", "$1");
        AddSingularRule("(tive)s$", "$1");
        AddSingularRule("([lr])ves$", "$1f");
        AddSingularRule("([^aeiouy]|qu)ies$", "$1y");
        AddSingularRule("(s)eries$", "$1eries");
        AddSingularRule("(m)ovies$", "$1ovie");
        AddSingularRule("(x|ch|ss|sh)es$", "$1");
        AddSingularRule("([m|l])ice$", "$1ouse");
        AddSingularRule("(bus)es$", "$1");
        AddSingularRule("(o)es$", "$1");
        AddSingularRule("(shoe)s$", "$1");
        AddSingularRule("(cris|ax|test)es$", "$1is");
        AddSingularRule("(octop|vir)i$", "$1us");
        AddSingularRule("(alias|status)$", "$1");
        AddSingularRule("(alias|status)es$", "$1");
        AddSingularRule("^(ox)en", "$1");
        AddSingularRule("(vert|ind)ices$", "$1ex");
        AddSingularRule("(matr)ices$", "$1ix");
        AddSingularRule("(quiz)zes$", "$1");

        AddIrregularRule("person", "people");
        AddIrregularRule("man", "men");
        AddIrregularRule("child", "children");
        AddIrregularRule("sex", "sexes");
        AddIrregularRule("tax", "taxes");
        AddIrregularRule("move", "moves");
        AddUnknownCountRule("equipment");
        AddUnknownCountRule("information");
        AddUnknownCountRule("rice");
        AddUnknownCountRule("money");
        AddUnknownCountRule("species");
        AddUnknownCountRule("series");
        AddUnknownCountRule("fish");
        AddUnknownCountRule("sheep");

    }
    public static string MakeInitialCaps(string word)
    {
        return String.Concat(word.Substring(0, 1).ToUpper(), word.Substring(1).ToLower());
    }
    private static void AddUnknownCountRule(string word)
    {
        _uncountables.Add(word.ToLower());
    }
    private static void AddPluralRule(string rule, string replacement)
    {
        _plurals.Add(new InflectorRule(rule, replacement));
    }
    public static string MakeSingular(string word)
    {
        return ApplyRules(_singulars, word);
    }
    private static string ApplyRules(IList<InflectorRule> rules, string word)
    {
        string result = word;
        if (!_uncountables.Contains(word.ToLower()))
        {
            for (int i = rules.Count - 1; i >= 0; i--)
            {
                string currentPass = rules[i].Apply(word);
                if (currentPass != null)
                {
                    result = currentPass;
                    break;
                }
            }
        }
        return result;
    }
    public static string ToHumanCase(string lowercaseAndUnderscoredWord)
    {
        return MakeInitialCaps(Regex.Replace(lowercaseAndUnderscoredWord, @"_", " "));
    }
    public static string AddUnderscores(string pascalCasedWord)
    {
        return Regex.Replace(Regex.Replace(Regex.Replace(pascalCasedWord, @"([A-Z]+)([A-Z][a-z])", "$1_$2"), @"([a-z\d])([A-Z])", "$1_$2"), @"[-\s]", "_").ToLower();
    }
    public static string ToTitleCase(string word)
    {
        return Regex.Replace(ToHumanCase(AddUnderscores(word)), @"\b([a-z])",
            delegate(Match match) { return match.Captures[0].Value.ToUpper(); });
    }
    /// <summary>
    /// Adds the singular rule.
    /// </summary>
    /// <param name="rule">The rule.</param>
    /// <param name="replacement">The replacement.</param>
    private static void AddSingularRule(string rule, string replacement)
    {
        _singulars.Add(new InflectorRule(rule, replacement));
    }
    private static void AddIrregularRule(string singular, string plural)
    {
        AddPluralRule(String.Concat("(", singular[0], ")", singular.Substring(1), "$"), String.Concat("$1", plural.Substring(1)));
        AddSingularRule(String.Concat("(", plural[0], ")", plural.Substring(1), "$"), String.Concat("$1", singular.Substring(1)));
    }



    private class InflectorRule
    {
        /// <summary>
        /// 
        /// </summary>
        public readonly Regex regex;

        /// <summary>
        /// 
        /// </summary>
        public readonly string replacement;

        /// <summary>
        /// Initializes a new instance of the <see cref="InflectorRule"/> class.
        /// </summary>
        /// <param name="regexPattern">The regex pattern.</param>
        /// <param name="replacementText">The replacement text.</param>
        public InflectorRule(string regexPattern, string replacementText)
        {
            regex = new Regex(regexPattern, RegexOptions.IgnoreCase);
            replacement = replacementText;
        }

        /// <summary>
        /// Applies the specified word.
        /// </summary>
        /// <param name="word">The word.</param>
        /// <returns></returns>
        public string Apply(string word)
        {
            if (!regex.IsMatch(word))
                return null;

            string replace = regex.Replace(word, replacement);
            if (word == word.ToUpper())
                replace = replace.ToUpper();

            return replace;
        }
    }
    #endregion
}
//}
