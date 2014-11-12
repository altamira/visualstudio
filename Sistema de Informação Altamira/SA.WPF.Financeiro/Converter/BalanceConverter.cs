using System;
using System.Windows;
using System.Windows.Data;
using SA.WPF.Financial.Enum;
using SA.WPF.Financial.Model;

namespace SA.WPF.Financial.Converter
{
    public class BalanceConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value != null && value.GetType().BaseType == typeof(Transaction))
            {
                Transaction m = (Transaction)value;

                m.Account.Balance += m.TRANSACTIONTYPE == TRANSACTIONTYPE.Debito ? m.Valor * -1 : m.Valor;

                return m.Account.Balance;
            }

            return DependencyProperty.UnsetValue;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotSupportedException();
        }
    }
}
