using System;
using System.Windows;
using System.Windows.Data;
using System.Windows.Media;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Converter
{
    public class TransactionTypeToColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            TRANSACTIONTYPE input = (TRANSACTIONTYPE)value;

            switch (input)
            {
                case TRANSACTIONTYPE.Debito:
                    return Brushes.Red;
                case TRANSACTIONTYPE.Credito:
                    return Brushes.Blue;
                default:
                    return DependencyProperty.UnsetValue;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotSupportedException();
        }
    }

}
