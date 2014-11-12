using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace SA.WPF.ControlLibrary
{
    /// <summary>
    /// Interaction logic for UserControl1.xaml
    /// </summary>
    public partial class Name : UserControl
    {
        public Name()
        {
            InitializeComponent();
        }

        #region Beravior

        private void Name_GotFocus(object sender, RoutedEventArgs e)
        {
            BrushConverter b = new BrushConverter();
            Value.Background = (Brush)b.ConvertFrom("#FFFAE55A");
        }

        private void Name_LostFocus(object sender, RoutedEventArgs e)
        {
            Value.Background = Brushes.White;
        }

        #endregion

    }
}
