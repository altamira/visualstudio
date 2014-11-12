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
using System.Windows.Shapes;
using SA.Data.Models;
using System.Data.Entity;

namespace SA.WPF.Application.Financeiro.ConciliacaoBancaria
{
    /// <summary>
    /// Interaction logic for Conciliacao.xaml
    /// </summary>
    public partial class Conciliacao : Window
    {
        private SAContext context = new SAContext();
        public Conciliacao()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            System.Windows.Data.CollectionViewSource bancoViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("bancoViewSource")));
            //bancoViewSource.Source = 
            // Load is an extension method on IQueryable, 
            // defined in the System.Data.Entity namespace.
            // This method enumerates the results of the query, 
            // similar to ToList but without creating a list.
            // When used with Linq to Entities this method 
            // creates entity objects and adds them to the context.
            
            //var banco = context.Banco.FirstOrDefault();

            //context.Banco.Load();

            //bancoViewSource.Source = context.Banco.Local;
            //bancoDataGrid.DataContext = context.Banco.Local;
            // After the data is loaded call the DbSet<T>.Local property 
            // to use the DbSet<T> as a binding source.
            //bancoViewSource.Source = context.Banco;
             
            
        }
    }
}
