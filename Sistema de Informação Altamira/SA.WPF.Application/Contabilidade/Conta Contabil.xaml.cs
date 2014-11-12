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
using System.Windows.Shapes;

namespace SA.WPF.Application
{
    /// <summary>
    /// Interaction logic for Conta_Contabil.xaml
    /// </summary>
    public partial class Conta_Contabil : RibbonWindow
    {
        public Conta_Contabil()
        {
            InitializeComponent();

            var q = SA.Data.Models.GPIMAC.FluxoCaixa.Titulo.ListAll();

            LancamentosGridView.DataContext = q;
        }
    }
}
