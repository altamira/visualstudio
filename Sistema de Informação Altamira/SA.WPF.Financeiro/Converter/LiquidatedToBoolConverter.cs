using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Converter
{
    class LiquidatedToBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return (bool)value; 

            LIQUIDATED input = (LIQUIDATED)value;

            switch (input)
            {
                case LIQUIDATED.YES:
                    return true;
                case LIQUIDATED.NO:
                    return false;
                default:
                    return DependencyProperty.UnsetValue;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return (bool)value; 

        }
    }
}
