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
using SA.Data.Models.Financeiro.Bancos;

namespace SA.WPF.Application.Financeiro.ContasPagar
{
    /// <summary>
    /// Interaction logic for Boleto.xaml
    /// </summary>
    public partial class Boleto : Window
    {
        public Boleto()
        {
            InitializeComponent();

            Bradesco.CNAB.Instrucao i = new Bradesco.CNAB.Instrucao();

            i.BANCO_FORNECEDOR = SA.Data.Models.Financeiro.Bancos.CODIGO.BRADESCO;
            i.RESERVADO_USO_EMPRESA = "1234";
            i.TIPO_DOCUMENTO = Bradesco.CNAB.TIPO_DOCUMENTO.NOTA_FISCAL;
            i.NUMERO_NOTA_FISCAL = "77219";
            i.CODIGO_LANCAMENTO = "0";

            //LogoBanco.Source = new ImageSource(string.Format("/Images/Bancos/{0}.jpg", ((int)i.BANCO_FORNECEDOR).ToString().PadLeft(3, '0').Substring(1, 3)));

            DataContext = i;
        }
    }
}
