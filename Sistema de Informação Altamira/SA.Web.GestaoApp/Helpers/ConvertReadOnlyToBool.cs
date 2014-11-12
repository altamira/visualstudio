using System.Windows.Data;
using System.Windows;
using System;

namespace GestaoApp.Helpers
{
    public class ConvertReadOnlyToBool : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value != null)
                if (value.GetType() == typeof(bool))
                {
                    bool ReadOnly = (bool)value;

                    if (ReadOnly)
                        return false;
                }

            return true;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }

    }
}
