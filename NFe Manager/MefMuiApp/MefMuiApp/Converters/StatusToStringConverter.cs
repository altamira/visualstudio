using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace WPF.Converters
{
    class StatusToStringConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object param, CultureInfo culture)
        {
            switch ((Model.Status)value)
            {
                case Model.Status.New:
                    return "";
                case Model.Status.Accepted:
                    return "Autorizado";
                case Model.Status.Rejected:
                    return "Desautorizado";
                case Model.Status.Divergent:
                    return "Divergente";
                case Model.Status.Received:
                    return "Recebido";
                case Model.Status.Exception:
                    return "Erro";
                default:
                    return "?";
            }
        }

        public object ConvertBack(object value, Type targetType, object param, CultureInfo culture)
        {
            return value;
        }
    }
}
