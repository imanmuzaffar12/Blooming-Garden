using Framework.Shared.Enums;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace Framework.Web.CommonCode.Helpers
{
    public class DateTimeHelper
    {
        #region Public Constants
        public const string EnglishUSCultureValue = "en-US";
        public const string ArabicSaudiCultureValue = "ar-SA";
        public const string ArabicUAECultureValue = "ar-AE";

        public const string DefaultDateFormat = "dd/MM/yyyy";
        public const string ArabicDateFormat = "yyyy/MM/dd";

        public const string OnlyMonthNameFormat = "MMMM";

        public const string DefaultDateTimeWithSecondsFormat = "dd/MM/yyyy hh:mm:ss tt";

        public const string FullDateFormat = " dd - MM -yyyy";

        public const string DateFormatForFinancial = "dd - MMMM - yyyy";
        public const string DateFormatForCompanyFinancialStatement = "dd MMMM yy";

        public const string ProfileVisitorDateFormat = "hh:mm - dd";
        public const string AssemblyMeetingDateTimeFormat = "dd MMMM yy hh:mm t";
        public const string AssemblyMeetingDateFormat = "dd MMMM yy";
        private static CultureInfo _cultureInfo;
        private static System.Globalization.Calendar _calendar;
        #endregion

        #region Private Methods
        private static CultureInfo GetCultureInfo(string cultureValue)
        {
            //if (object.ReferenceEquals(_cultureInfo, null))
            _cultureInfo = new CultureInfo(cultureValue, false);

            return (_cultureInfo);
        }

        private static System.Globalization.Calendar GetGregorianCalendar()
        {
            if (object.ReferenceEquals(_calendar, null))
                _calendar = new GregorianCalendar();

            return (_calendar);
        }

        private static string ApplyFormat(CultureInfo culture, DateTime dateTime, string format)
        {
            DateTimeFormatInfo dInfo = culture.DateTimeFormat;
            dInfo.Calendar = GetGregorianCalendar();

            return (dateTime.ToString(format, dInfo));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// This method will return an integer representing the number of days between two
        /// particular dates passed to a method
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static int GetDaysDifference(DateTime startDate, DateTime endDate)
        {
            TimeSpan timeDifference = endDate - startDate;

            try
            {
                return Int32.Parse(timeDifference.TotalDays.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        /// <summary>
        /// This method will return an integer representing the number of months between two
        /// particular dates passed to a method
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static int GetMonthsCountBetweenDates(DateTime startDate, DateTime endDate)
        {
            TimeSpan timeDifference = endDate - startDate;

            DateTime resultDate = DateTime.MinValue + timeDifference;

            int monthDifference = resultDate.Month - 1;

            return monthDifference;
        }

        /// <summary>
        /// This method will take 2 dates as input and return the Generic List of DateTime objects. Each
        /// object represent 1 of the months between the 2 dates and is set in the dd/MM/yyyy format while
        /// the current day of the month is set to 1. For example: 01/01/2010, 01/02/2010, 01/03/2010 etc..
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static List<DateTime> GetMonthsBetweenDates(DateTime startDate, DateTime endDate)
        {
            TimeSpan timeDifference = endDate - startDate;

            DateTime resultDate = DateTime.MinValue + timeDifference;

            int monthDifference = resultDate.Month - 1;

            if (monthDifference > 0)
            {
                List<DateTime> result = new List<DateTime>();
                for (int i = 0; i < monthDifference; i++)
                {
                    DateTime tempDate = startDate.AddMonths(1);
                    DateTime dateToAdd = new DateTime(tempDate.Date.Year, tempDate.Month, 1);

                    result.Add(dateToAdd);
                }
                return result;
            }
            else
            {
                return null;
            }
        }
        #endregion
    }
}