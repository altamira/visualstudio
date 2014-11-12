using System;
using System.Text.RegularExpressions;

namespace GestaoApp.Controls
{
    public class Validator
    {
        public static bool IsValidShortDate(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ */ *[0-9]+ */ *[0-9][0-9] *"))
                    return false;
                else
                {
                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
        public static bool IsValidLongDate(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ */ *[0-9]+ */ *[0-9][0-9][0-9][0-9] *"))
                    return false;
                else
                {
                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        public static bool IsValidShortTime(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ *: *[0-9]+ *"))
                    return false;
                else
                {


                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
        public static bool IsValidLongTime(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ *: *[0-9]+ *: *[0-9][0-9]*"))
                    return false;
                else
                {
                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
        public static bool IsValidShortAMPMTime(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ *: *[0-9]+ *AM|PM"))
                    return false;
                else
                {
                    if (dateValue.IndexOf("AM") > 0)
                        dateValue.Replace("AM", "");
                    else if (dateValue.IndexOf("PM") > 0)
                        dateValue.Replace("PM", "");
                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
        public static bool IsValidLongAMPMTime(string dateValue)
        {
            try
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(dateValue, " *[0-9]+ *: *[0-9]+ *: *[0-9][0-9]*AM|PM"))
                    return false;
                else
                {
                    if (dateValue.IndexOf("AM") > 0)
                        dateValue.Replace("AM", "");
                    else if (dateValue.IndexOf("PM") > 0)
                        dateValue.Replace("PM", "");

                    Convert.ToDateTime(dateValue);
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        public static bool IsValidEmail(string strEmail)
        {
            string strRegex = @"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
                              @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
                              @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
            Regex re = new Regex(strRegex);
            if (re.IsMatch(strEmail.Trim()))
                return (true);
            else
                return (false);
        }
    }
}
