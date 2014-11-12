using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;
using SA.Data.Models;

namespace SA.WPF.Converters
{
    public class SaldoMovimentoConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value != null && value.GetType().BaseType == typeof(SA.Data.Models.Movimento))
            {
                SA.Data.Models.Movimento m = (SA.Data.Models.Movimento)value;

                m.Conta1.Saldo += m.Operacao == OPERACAO.Debito ? m.Valor * -1 : m.Valor;

                return m.Conta1.Saldo;
            }

            return DependencyProperty.UnsetValue;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotSupportedException();
        }
    }
}
