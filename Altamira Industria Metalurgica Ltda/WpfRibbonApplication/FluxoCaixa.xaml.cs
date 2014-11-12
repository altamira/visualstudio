using System.Windows.Controls;

namespace SA.WpfRibbonApplication
{
    /// <summary>
    /// Interação lógica para FluxoCaixa.xam
    /// </summary>
    public partial class FluxoCaixa : UserControl
    {
        public FluxoCaixa()
        {
            InitializeComponent();

            var q = SA.Data.Models.GPIMAC.FluxoCaixa.Titulo.ListAll();

            LancamentosGridView.DataContext = q;
        }
    }
}
