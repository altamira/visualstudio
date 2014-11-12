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
using Microsoft.Win32;
using BoletoNet;
using System.IO;
using System.Text.RegularExpressions;
using SA.Data.Models.Financeiro.Bancos;

namespace SA.WPF.Application.Financeiro
{
    /// <summary>
    /// Interação lógica para CNAB.xam
    /// </summary>
    public partial class CNAB : UserControl
    {
        public CNAB()
        {
            InitializeComponent();
        }

        private void AbrirArquivo_Click(object sender, RoutedEventArgs e)
        {
            bool CNAB400 = true;

            try
            {
                BoletoNet.Banco bco = new BoletoNet.Banco(237);

                OpenFileDialog openFileDialog = new OpenFileDialog();
                openFileDialog.FileName = "";
                openFileDialog.Title = "Selecione um arquivo de retorno";
                openFileDialog.Filter = "Arquivos de Retorno (*.ret)|*.ret|Todos Arquivos (*.*)|*.*";
                if (openFileDialog.ShowDialog() == true  /*== DialogResult.OK*/)
                {

                    if (CNAB400)
                    {
                        ArquivoRetornoCNAB400 cnab400 = null;
                        if (openFileDialog.CheckFileExists == true)
                        {
                            //cnab400 = new ArquivoRetornoCNAB400();
                            //cnab400.LinhaDeArquivoLida += new EventHandler<LinhaDeArquivoLidaArgs>(cnab400_LinhaDeArquivoLida);
                            //cnab400.LerArquivoRetorno(bco, openFileDialog.OpenFile());

                            SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Retorno r = new SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Retorno(/*Data.Models.Financeiro.Bancos.Numero.Bradesco*/);

                            Stream s = openFileDialog.OpenFile();
                            StreamReader f = new StreamReader(s);
                            r.Parse(f);

                            //foreach (string m in c.OfType<string>())
                            //{
                            //    Console.WriteLine(m);
                            //}

                            //foreach (Match m in c)
                            //{
                            //    Console.WriteLine(String.Format("Tipo:{0}, {1}", m.Groups["Tipo_Registro"].Value, m.Groups["Fornecedor"].Value));
                            //}
                            
                        }

                        if (cnab400 == null)
                        {
                            MessageBox.Show("Arquivo não processado!");
                            return;
                        }

                        CNABDataGrid.Items.Clear();

                        CNABDataGrid.DataContext = cnab400.ListaDetalhe;

                        //foreach (DetalheRetorno detalhe in cnab400.ListaDetalhe)
                        //{
                            //ListViewItem li = new ListViewItem(detalhe.NomeSacado.ToString().Trim());
                            //li.Tag = detalhe;

                            //li.SubItems.Add(detalhe.DataVencimento.ToString("dd/MM/yy"));
                            //li.SubItems.Add(detalhe.DataCredito.ToString("dd/MM/yy"));

                            //li.SubItems.Add(detalhe.ValorTitulo.ToString("###,###.00"));

                            //li.SubItems.Add(detalhe.ValorPago.ToString("###,###.00"));
                            //li.SubItems.Add(detalhe.CodigoOcorrencia.ToString());
                            //li.SubItems.Add("");
                            //li.SubItems.Add(detalhe.NossoNumero.ToString());
                            //lstReturnFields.Items.Add(li);
                        //}
                    }
                    else if (CNAB400)
                    {
                        ArquivoRetornoCNAB240 cnab240 = null;
                        if (openFileDialog.CheckFileExists == true)
                        {
                            cnab240 = new ArquivoRetornoCNAB240();
                            //cnab240.LinhaDeArquivoLida += new EventHandler<LinhaDeArquivoLidaArgs>(cnab240_LinhaDeArquivoLida);
                            cnab240.LerArquivoRetorno(bco, openFileDialog.OpenFile());
                        }

                        if (cnab240 == null)
                        {
                            MessageBox.Show("Arquivo não processado!");
                            return;
                        }


                        //lstReturnFields.Items.Clear();

                        //foreach (DetalheRetornoCNAB240 detalhe in cnab240.ListaDetalhes)
                        //{
                        //    ListViewItem li = new ListViewItem(detalhe.SegmentoT.NomeSacado.Trim());
                        //    li.Tag = detalhe;

                        //    li.SubItems.Add(detalhe.SegmentoT.DataVencimento.ToString("dd/MM/yy"));
                        //    li.SubItems.Add(detalhe.SegmentoU.DataCredito.ToString("dd/MM/yy"));
                        //    li.SubItems.Add(detalhe.SegmentoT.ValorTitulo.ToString("###,###.00"));
                        //    li.SubItems.Add(detalhe.SegmentoU.ValorPagoPeloSacado.ToString("###,###.00"));
                        //    li.SubItems.Add(detalhe.SegmentoU.CodigoOcorrenciaSacado.ToString());
                        //    li.SubItems.Add("");
                        //    li.SubItems.Add(detalhe.SegmentoT.NossoNumero);
                        //    lstReturnFields.Items.Add(li);
                        //}
                    }
                    MessageBox.Show("Arquivo aberto com sucesso!");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Erro ao abrir arquivo de retorno.");
            }
        }

        public void GeraArquivoCNAB400(IBanco banco, Cedente cedente, Boletos boletos)
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "Arquivos de Retorno (*.rem)|*.rem|Todos Arquivos (*.*)|*.*";
            if (saveFileDialog.ShowDialog() == true /*== DialogResult.OK*/)
            {
                ArquivoRemessa arquivo = new ArquivoRemessa(TipoArquivo.CNAB400);
                arquivo.GerarArquivoRemessa("0", banco, cedente, boletos, saveFileDialog.OpenFile(), 1);

                MessageBox.Show("Arquivo gerado com sucesso!", "Teste",
                                MessageBoxButton.OK,
                                MessageBoxImage.Information);
            }
        }

        private void GravarArquivo_Click(object sender, RoutedEventArgs e)
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "Arquivos de Retorno (*.rem)|*.rem|Todos Arquivos (*.*)|*.*";
            if (saveFileDialog.ShowDialog() == true /*== DialogResult.OK*/)
            {
                //ArquivoRemessa arquivo = new ArquivoRemessa(TipoArquivo.CNAB400);
                //arquivo.GerarArquivoRemessa("0", banco, cedente, boletos, saveFileDialog.OpenFile(), 1);

                //SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Remessa r = new SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Remessa(/*Data.Models.Financeiro.Bancos.Numero.Bradesco*/);

                uint[] i = {0};

                //try { i = "9999".ToList().Cast<int>().ToArray(); }
                //catch {
                //    try { i = "9999999999".ToCharArray().Select(c => int.Parse(c.ToString())).ToArray(); }
                //    catch (Exception ex)
                //    {
                //        Console.WriteLine(ex.ToString());
                //    }
                //}

                i = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
                uint digito = Bradesco.Modulo11(i);

                //if (r.Parse(saveFileDialog.OpenFile()))
                //    MessageBox.Show("Arquivo gerado com sucesso!", "CNAB",
                //                MessageBoxButton.OK,
                //                MessageBoxImage.Information);
            }
        }

    }
}
