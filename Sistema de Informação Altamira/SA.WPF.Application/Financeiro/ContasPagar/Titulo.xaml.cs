using System.Windows;
using SA.Data.Models.Financeiro.Bancos;

namespace SA.WPF.Application.Financeiro.ContasPagar
{
    /// <summary>
    /// Interaction logic for Lancamento_de_Boleto_Bancario.xaml
    /// </summary>
    public partial class Titulo : Window
    {
        public Titulo()
        {
            InitializeComponent();

            Bradesco.CNAB.Instrucao i = new Bradesco.CNAB.Instrucao();

            i.RESERVADO_USO_EMPRESA = "1234";
            i.TIPO_DOCUMENTO = Bradesco.CNAB.TIPO_DOCUMENTO.NOTA_FISCAL;
            i.NUMERO_NOTA_FISCAL = "77219";
            i.CODIGO_LANCAMENTO = "0";

            LayoutRoot.DataContext = i;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Bradesco.CNAB.Instrucao i = LayoutRoot.DataContext as Bradesco.CNAB.Instrucao;

            Bradesco.CodigoBarras b = new Bradesco.CodigoBarras(i.CODIGO_BARRAS);
        }
    }
}
