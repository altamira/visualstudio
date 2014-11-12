using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Converter
{
    public class TransactionTypeToBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object param, CultureInfo culture)
        {
            return value.Equals(param);
        }

        public object ConvertBack(object value, Type targetType, object param, CultureInfo culture)
        {
            return (bool)value ? param : ((TRANSACTIONTYPE)param == TRANSACTIONTYPE.Credito ? TRANSACTIONTYPE.Debito : TRANSACTIONTYPE.Credito); // (bool)value ? TRANSACTIONTYPE.Credito : TRANSACTIONTYPE.Debito;
            //return (bool)value ? param : Binding.DoNothing;
        }
    }
}
