using System.Windows;
using System.Windows.Controls;
using SA.PivotGrid.Models;
using SA.Data.Models;

namespace SA.WpfRibbonApplication
{
    /// <summary>
    /// Interação lógica para Materiais.xam
    /// </summary>
    public partial class Materiais : UserControl
    {
        UserModel u = new UserModel();
        Produto p;

        public Materiais()
        {
            InitializeComponent();

            u.Name = "Alessandro";

            Grid.DataContext = u;

            OrcamentoDataGrid.DataContext = SA.Data.Models.WBCCAD.Orcamento.ListAll();
            ProdutosDataGrid.DataContext = SA.Data.Models.Produto.ListAll();

            p = SA.Data.Models.Produto.SingleOrDefault();

            Grid.DataContext = p;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            //MessageBox.Show(u.Name);
            //u.Name += " 1234";
            //MessageBox.Show(u.Name);
            MessageBox.Show(p.ToString());
        }
    }
}
