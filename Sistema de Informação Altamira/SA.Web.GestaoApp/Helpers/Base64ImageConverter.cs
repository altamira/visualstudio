using System;
using System.Windows.Data;
using System.Windows.Media.Imaging;
using System.IO;
using System.Windows.Controls;

namespace GestaoApp.Helpers
{
    public class Base64ImageConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value!=null && value.ToString()!="")
            {
                string base64String = value as string;

                if (base64String == null)
                    return null;

                byte[] imageBytes = System.Convert.FromBase64String(base64String);
                MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length);

                BitmapImage image = new BitmapImage();
                image.SetSource(ms);
                return image;
            }
            return null;
            // Or ImageBrush
            //byte[] imageBytes = Convert.FromBase64String(base64String);
            //MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length))

            //BitmapImage image = new BitmapImage();
            //image.SetSource(ms);
            //return image;

        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

}
