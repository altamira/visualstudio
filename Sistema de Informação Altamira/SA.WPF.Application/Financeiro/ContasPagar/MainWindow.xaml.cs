using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace SA.WPF.Application.Financeiro.ContasPagar
{
    /// <summary>
    /// Interaction logic for Contas_a_Pagar.xaml
    /// </summary>
    public partial class MainWindow : RibbonWindow
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void IncluirBoletoRibbonButton_Click(object sender, RoutedEventArgs e)
        {
            //Titulo l = new Titulo();

            //l.ShowDialog();

            Boleto b = new Boleto();
            b.Show();
        }
    }
}
