using System.Windows.Data;
using System.Windows;
using System;

namespace GestaoApp.Helpers
{
    public class ConvertReadOnlyToVisibility : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value != null)
                if (value.GetType() == typeof(bool))
                {
                    bool canvisible = (bool)value;

                    if (canvisible)
                        return Visibility.Collapsed;
                }

            return Visibility.Visible;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }

    }
}
