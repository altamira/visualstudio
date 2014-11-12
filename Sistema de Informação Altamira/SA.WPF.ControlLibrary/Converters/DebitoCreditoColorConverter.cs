using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Data;
using System.Windows.Media;

namespace SA.WPF.Converters
{
    public class DebitoCreditoColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            SA.Data.Models.OPERACAO input = (SA.Data.Models.OPERACAO)value;

            switch (input)
            {
                case SA.Data.Models.OPERACAO.Debito:
                    return Brushes.Red;
                case SA.Data.Models.OPERACAO.Credito:
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

    public class PositivoNegativoColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            try
            {
                decimal d = (decimal)value;

                if (d >= 0)
                    return Brushes.Blue;
                else
                    return Brushes.Red;
            }
            catch
            {
                return DependencyProperty.UnsetValue;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotSupportedException();
        }
    }
}
