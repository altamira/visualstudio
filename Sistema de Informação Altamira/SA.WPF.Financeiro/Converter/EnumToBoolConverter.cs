using System;
using System.Globalization;
using System.Windows.Data;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Converter
{
    public class EnumToBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object param, CultureInfo culture)
        {
            return value.Equals(param);
        }

        public object ConvertBack(object value, Type targetType, object param, CultureInfo culture)
        {
            return param; 
        }
    }
}
