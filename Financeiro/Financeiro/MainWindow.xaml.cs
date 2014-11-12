using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data.Entity;

namespace Financeiro
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        SAContext context = new SAContext();
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {

            System.Windows.Data.CollectionViewSource movimentoViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("movimentoViewSource")));
            // Load data by setting the CollectionViewSource.Source property:
            using (SAContext ctx = context)
            {
                context.Movimento.Load();
                //movimentoViewSource.Source = ctx.Movimento.Local;
                movimentoViewSource.Source = ctx.Movimento.Local;
            }

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            SAContext context = new SAContext();
            context.SaveChanges();
        }


    }
}
