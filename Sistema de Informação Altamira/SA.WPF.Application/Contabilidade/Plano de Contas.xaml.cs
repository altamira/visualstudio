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

namespace SA.WPF.Application.Contabilidade
{
    /// <summary>
    /// Interaction logic for Plano_de_Contas.xaml
    /// </summary>
    public partial class Plano_de_Contas : UserControl
    {
        public Plano_de_Contas()
        {
            InitializeComponent();

            var q = SA.Data.Models.GPIMAC.FluxoCaixa.Titulo.ListAll();

            LancamentosGridView.DataContext = q;
        }
    }
}
