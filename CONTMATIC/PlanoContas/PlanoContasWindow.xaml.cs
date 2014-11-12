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
using System.ComponentModel;
using CONTMATIC.Geral;
using CONTMATIC.Empresas;
using System.IO;
using CONTMATIC.Service;
using System.Globalization;
using System.Net;
using System.ServiceModel.Description;
using System.Security.Permissions;
using System.Security;
using System.Security.Cryptography;
using System.Collections.ObjectModel;

namespace CONTMATIC
{
    /// <summary>
    /// Interaction logic for PlContas.xaml
    /// </summary>
    public partial class PlContasWindow : Window
    {
        private const float Version = 1.6f;

        private const string EmpresaAtiva = "ALTAMIRA";
        private const string AnoAtivo = "2014";

        //PlCtaAux plctaaux = new PlCtaAux();
        PlContas plcontas = new PlContas();

        List<Participante> Participantes;

        List<ContaContabil> PlanoContas = new List<ContaContabil>();

        private Byte[] pvClientId = new Byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        private void SetClientId()
        {
            int lThreadId;
            short lPID;

            lThreadId = System.Threading.Thread.CurrentThread.ManagedThreadId;
            lPID = (short)(lThreadId % short.MaxValue);
            //pvClientId = New Byte() {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, _
            //0, 0, _
            //0, 0}
            pvClientId[12] = (byte)'W';
            pvClientId[13] = (byte)'S';
            pvClientId[15] = (byte)(lPID % 256);
            pvClientId[14] = (byte)((lPID - pvClientId[15]) / 256);
        }

        public string GenerateToken(DateTime dateTime)
        {
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            //DateTime dateTime = DateTime.UtcNow;
            dateTime = dateTime.AddSeconds(-dateTime.Second);
            if (dateTime.Minute % 2 != 0)
                dateTime = dateTime.AddMinutes(1);

            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(dateTime.ToString());
            byte[] hash = md5.ComputeHash(inputBytes);

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }

        //Create a Delegate that matches 
        //the Signature of the ProgressBarCadastros's SetValue method
        private delegate void UpdateProgressBarCadastrosDelegate(System.Windows.DependencyProperty dp, Object value);
        //private delegate void UpdateProgressLabelDelegate(System.Windows.DependencyProperty dp, Object value);

        public PlContasWindow()
        {
            InitializeComponent();

            //WindowState = WindowState.Maximized;

            StatusBarLabel.Content = "Inicializando, aguarde...";

            CheckVersion();

            SetClientId();

            SetTitle();

            StatusBarLabel.Content = "";

            DataInicialDatePicker.Text = DateTime.Now.Date.AddDays(DateTime.Now.Day * -1 + 1).ToShortDateString();
            DataFinalDatePicker.Text = DateTime.Now.Date.ToShortDateString();

            //LoadData();
        }

        private void CheckVersion()
        {
            try
            {

                Service.PlanoContasClient client = new Service.PlanoContasClient();

                //client.ClientCredentials.HttpDigest.ClientCredential = new NetworkCredential("Administrador", "brkm39$sxz");
                //client.ClientCredentials.HttpDigest.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;

                client.ClientCredentials.Windows.ClientCredential.Domain = "ALTAMIRA";
                client.ClientCredentials.Windows.ClientCredential.UserName = "Administrador";
                client.ClientCredentials.Windows.ClientCredential.Password = "brkm39$sxz";

                DateTime now = DateTime.UtcNow;
                string token = GenerateToken(now);

                client.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                client.Open();

                float CurrentVersion = client.GetCurrentVersion(token, now);
                //float CurrentVersion = client.GetCurrentVersion();

                string remotetoken = client.GetToken(now);

                client.Close();

                this.Cursor = Cursors.Arrow;

                if (token.CompareTo(remotetoken) != 0)
                {
                    MessageBox.Show("Não foi possivel validar a sessão do usuário.\n\nO programa será finalizado.", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Stop);
                    AppExit(this, new RoutedEventArgs());
                }

                if (Version < CurrentVersion)
                {
                    MessageBox.Show(string.Format("A versão deste programa é {0:F}, para funcionar corretamente precisa ser atualizado para a versão {1:F}.\n\nO programa será finalizado.", Version, CurrentVersion), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Stop);
                    AppExit(this, new RoutedEventArgs());
                }

            }
            catch (Exception ex)
            {
                this.Cursor = Cursors.Arrow;

                MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}", Properties.Settings.Default.WebServiceURL, ex.Message, ex.InnerException != null ? ex.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                //AppExit(this, new RoutedEventArgs());
            }

        }

        private void SetTitle()
        {
            this.Title = string.Format("Altamira - Integracao Contabil - Plano de Contas Atual {0}. (versão {1:f}).", Properties.Settings.Default.PlanoContasAtual.ToString(), Version);
        }

        public void LoadData()
        {
            short r;

            FileIOPermission f1 = new FileIOPermission(FileIOPermissionAccess.Read, Properties.Settings.Default.GeralPath);
            f1.AddPathList(FileIOPermissionAccess.Write | FileIOPermissionAccess.Read, Properties.Settings.Default.GeralPath);
            try
            {
                f1.Demand();
            }
            catch (SecurityException s)
            {
                Console.WriteLine(s.Message);
            }

            FileIOPermission f2 = new FileIOPermission(FileIOPermissionAccess.Read, Properties.Settings.Default.EmpresaPath);
            f2.AddPathList(FileIOPermissionAccess.Write | FileIOPermissionAccess.Read, Properties.Settings.Default.EmpresaPath);
            try
            {
                f2.Demand();
            }
            catch (SecurityException s)
            {
                Console.WriteLine(s.Message);
            }

            StatusBarLabel.Content = "Verificando arquivos...";

            #region Verificação de Arquivos
            // Verifica configuração
            if (!Directory.Exists(Properties.Settings.Default.GeralPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.GeralPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(Properties.Settings.Default.EmpresaPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.EmpresaPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva)))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva)), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo)))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo)), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (Properties.Settings.Default.PlanoContasAtual <= 0)
            {
                MessageBox.Show(string.Format("O código do Plano de Contas Atual é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (Properties.Settings.Default.PlanoContasAnterior <= 0)
            {
                MessageBox.Show(string.Format("O código do Plano de Contas Anterior é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"NPCCTB.btr")))
            {
                MessageBox.Show(string.Format("O arquivo com o cadastro de Plano de Contas em '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            NPCCTB npcctb = new NPCCTB();

            npcctb.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr");

            if ((r = npcctb.btrOpen(NPCCTB.OpenModes.Normal)) == 0)
            {
                npcctb.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas Atual {0} não foi encontrado !", Properties.Settings.Default.PlanoContasAtual.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                npcctb.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAnterior;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas Anterior {0} não foi encontrado !", Properties.Settings.Default.PlanoContasAtual.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }
            else
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")));
                return;
            }

            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            #endregion

            #region Carregando Plano de Contas do CONTMATIC

            StatusBarLabel.Content = "Carregando Plano de Contas do CONTMATIC...";

            List<string> plcContmatic = new List<string>();

            this.Cursor = Cursors.Wait;

            try
            {

                plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr");

                if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) == 0)
                {
                    plcontas.Keys.idxindex_3.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;

                    if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_3, pvClientId)) == 0)
                    {
                        do
                        {
                            plcContmatic.Add(plcontas.fldConta.PadRight(56));
                        } while ((r = plcontas.btrGetNext(PlContas.KeyName.index_3, pvClientId)) == 0);
                    }
                    //else
                    //MessageBox.Show(string.Format("Erro ao carregar os registros do cadastro de Plano de Contas do Contmatic no arquivo {0}. O código do erro é {1}.", plcontas.DataPath, result));
                }
                else
                {
                    MessageBox.Show(string.Format("Erro ao abrir o cadastro de Plano de Contas do Contmatic do arquivo {0}. O código do erro é {1}.", plcontas.DataPath, r), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                this.Cursor = Cursors.Arrow;
            }
            catch (Exception ex)
            {
                this.Cursor = Cursors.Arrow;

                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}.\b{1}.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"plcontas.btr"), ex.Message), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            #endregion

            #region Carregando Plano de Contas da Altamira

            StatusBarLabel.Content = "Carregando Plano de Contas da Altamira, aguarde...";

            Service.ContaContabil[] ContaContabilList;

            this.Cursor = Cursors.Wait;

            try
            {

                Service.PlanoContasClient plClient = new Service.PlanoContasClient();

                plClient.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                plClient.Open();

                ContaContabilList = plClient.PlanoContasList();

                plClient.Close();

                this.Cursor = Cursors.Arrow;
            }
            catch (Exception ex)
            {
                this.Cursor = Cursors.Arrow;

                MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}", Properties.Settings.Default.WebServiceURL, ex.Message, ex.InnerException != null ? ex.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            var query = from item in ContaContabilList
                        where !plcContmatic.Contains(item.Conta.Trim())
                        select item;

            PlanoContas = (from i in ContaContabilList //query
                     select new ContaContabil()
                     {
                         Conta = i.Conta,
                         ContaAntiga = i.ContaAntiga,
                         CNPJ = i.CNPJ,
                         Nome = i.Nome,
                         Tipo = i.Tipo,
                         Reduzida = i.Reduzida,
                         ReduzidaAntiga = i.ReduzidaAntiga,
                         Pessoa = i.Pessoa,
                         Selecionado = false,
                         Habilitado = true,
                         Situacao = ""
                     }).ToList<ContaContabil>();

            this.Cursor = Cursors.Wait;

            //plcontas.TrimStrings = true;

            foreach (ContaContabil i in PlanoContas)
            {
                //if (i.Tipo == "CL" || i.Tipo == "CF")
                //{
                //    i.Cliente = true;
                //}

                //if (i.Tipo == "FO" || i.Tipo == "CF")
                //{
                //    i.Fornecedor = true;
                //}

                plcontas.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                plcontas.Keys.idxindex_0.sgmConta = i.Conta.PadRight(56);

                // Verifica se o Plano e Conta já existem
                if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_0, pvClientId)) == 4)
                {
                    //plcontas.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContas;
                    //plcontas.Keys.idxindex_1.sgmDescricao = i.Nome;

                    //if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_1, pvClientId)) == 4)
                    //{
                        plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                        plcontas.Keys.idxindex_2.sgmReduzida = i.Reduzida;

                        if (i.Reduzida == 0 || (r = plcontas.btrGetEqual(PlContas.KeyName.index_0, pvClientId)) == 4)
                        {
                            //i.Habilitado = true;
                            i.Selecionado = true;
                            i.Situacao = "Novo";
                        }
                        else
                        {
                            //i.Habilitado = false;
                            i.Selecionado = false;
                            i.Situacao = "Cadastrado";
                        }
                    //}
                    //else
                    //{
                    //    i.Habilitado = false;
                    //    i.Selecionado = false;
                    //    i.Situacao = "Cadastrado";
                    //}
                }
                else
                {
                    //i.Habilitado = false;
                    i.Selecionado = false;
                    i.Situacao = "Cadastrado";
                }
            }

            PlanoContasDataGrid.ItemsSource = PlanoContas;

            plcontas.btrClose();
            npcctb.btrClose();
            #endregion

            #region Carregando Cadastro de Participantes

            StatusBarLabel.Content = "Carregando Cadastro de Participantes da Altamira, aguarde...";

            this.Cursor = Cursors.Wait;

            try
            {

                Service.PlanoContasClient pClient = new Service.PlanoContasClient();

                pClient.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                pClient.Open();

                Service.Participante[] ParticipantesList = pClient.ParticipantesList();

                pClient.Close();

                Participantes = (from i in ParticipantesList //query
                               select new Participante()
                               {
                                   CNPJ = i.CNPJ,
                                   Nome = i.Nome,
                                   Tipo = i.Tipo,
                                   CCCliente = i.CCCliente,
                                   CCFornecedor = i.CCFornecedor,
                                   Pessoa = i.Pessoa,
                                   Selecionado = true,
                                   Situacao = ""
                               }).ToList<Participante>();

                this.Cursor = Cursors.Arrow;
            }
            catch (Exception ex)
            {
                this.Cursor = Cursors.Arrow;

                MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}", Properties.Settings.Default.WebServiceURL, ex.Message, ex.InnerException != null ? ex.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // TODO Verificar se já existem e carregar o campo situação
            //foreach (Participante p in Participantes)
            //{

            //}

            ParticipantesDataGrid.ItemsSource = Participantes;

            #endregion

            #region Carregando Notas Fiscais
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro das Notas Fiscais '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            List<NotaFiscal> NotasFiscais = new List<NotaFiscal>();

            Notas notas = new Notas();

            notas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR");

            if ((r = notas.btrOpen(Notas.OpenModes.Read_Only, pvClientId)) == 0)
            {
                if ((r = notas.btrGetFirst(Notas.KeyName.index_0, pvClientId)) == 0)
                {
                    do
                    {
                        NotasFiscais.Add(new NotaFiscal()
                        {
                            Id = notas.fldId,
                            Data = DateTime.Parse(notas.fldData.Split('/')[0] + "/" + notas.fldData.Split('/')[1] + "/2013"),
                            Emissao = DateTime.Parse(notas.fldEmissao.Split('/')[0] + "/" + notas.fldEmissao.Split('/')[1] + "/2013"),
                            Numero = notas.fldNumero,
                            Operacao = notas.fldOperacao,
                            CNPJ = notas.fldCNPJ,
                            CentenaCFOP = notas.fldCentenaCFOP,
                            ContaContabil = notas.fldContaContabil.Trim().Length > 0 ? short.Parse(notas.fldContaContabil.Trim()) : (short)0,
                            ValorContabil = notas.fldValorContabil
                        });

                    } while (notas.btrGetNext(Notas.KeyName.index_0, pvClientId) == 0);
                }
            }

            NotasFiscaisDataGrid.ItemsSource = NotasFiscais;

            notas.btrClose(pvClientId);
            notas = null;
            #endregion

            StatusBarLabel.Content = "";

            this.Cursor = Cursors.Arrow;
        }

        private void CheckAll(object sender, RoutedEventArgs e)
        {
            if (CadastrosTabControl.SelectedIndex == 0)
            {
                foreach (ContaContabil i in PlanoContasDataGrid.ItemsSource)
                {
                    i.Selecionado = true;
                }
            }
            else if (CadastrosTabControl.SelectedIndex == 1)
            {
                foreach (Participante i in ParticipantesDataGrid.ItemsSource)
                {
                    i.Selecionado = true;
                }
            }
            else if (CadastrosTabControl.SelectedIndex == 2)
            {
                foreach (NotaFiscal i in NotasFiscaisDataGrid.ItemsSource)
                {
                    i.Selecionado = true;
                }
            }
        }

        private void UncheckAll(object sender, RoutedEventArgs e)
        {
            if (CadastrosTabControl.SelectedIndex == 0)
            {
                foreach (ContaContabil i in PlanoContasDataGrid.ItemsSource)
                {
                    i.Selecionado = false;
                }
            }
            else if (CadastrosTabControl.SelectedIndex == 1)
            {
                foreach (Participante i in ParticipantesDataGrid.ItemsSource)
                {
                    i.Selecionado = false;
                }
            }
            else if (CadastrosTabControl.SelectedIndex == 2)
            {
                foreach (NotaFiscal i in NotasFiscaisDataGrid.ItemsSource)
                {
                    i.Selecionado = false;
                }
            }
        }

        private void CheckAllLancamentos(object sender, RoutedEventArgs e)
        {
            foreach (LancamentoFluxoCaixa i in LancamentosFluxoCaixaDataGrid.ItemsSource)
            {
                i.Selecionado = true;
            }
        }

        private void UncheckAllLancamentos(object sender, RoutedEventArgs e)
        {
            foreach (LancamentoFluxoCaixa i in LancamentosFluxoCaixaDataGrid.ItemsSource)
            {
                i.Selecionado = false;
            }
        }

        private void AppExit(object sender, RoutedEventArgs e)
        {
            App.Current.Shutdown();
        }

        private void ConfigOpenWindow(object sender, RoutedEventArgs e)
        {
            Config cfg = new Config(pvClientId);
            cfg.ShowDialog();
            SetTitle();
            LoadData();
        }

        private void CarregarLista(object sender, RoutedEventArgs e)
        {
            LoadData();
        }

        private void ProcurarContaContabilButton(object sender, RoutedEventArgs e)
        {
            PlanoContasDataGrid.SelectedIndex = -1;
            ProcurarProximoContaContabilButton(sender, e);
        }

        private void ProcurarProximoContaContabilButton(object sender, RoutedEventArgs e)
        {
            for (int i = PlanoContasDataGrid.SelectedIndex == -1 ? 0 : PlanoContasDataGrid.SelectedIndex + 1; i < PlanoContasDataGrid.Items.Count; i++)
            {
                ContaContabil item = (ContaContabil)PlanoContasDataGrid.Items[i];

                if (item.Nome.Trim().ToLower().Contains(ProcurarContaContabilTextbox.Text.Trim().ToLower()) ||
                    item.Conta.Trim().ToLower().Contains(ProcurarContaContabilTextbox.Text.Trim().ToLower()) ||
                    item.ContaAntiga.Trim().ToLower().Contains(ProcurarContaContabilTextbox.Text.Trim().ToLower()) ||
                    item.CNPJ.Trim().ToLower().Contains(ProcurarContaContabilTextbox.Text.Trim().ToLower()) ||
                    item.Reduzida.ToString().Contains(ProcurarContaContabilTextbox.Text.Trim()) ||
                    item.ReduzidaAntiga.ToString().Contains(ProcurarContaContabilTextbox.Text.Trim()))
                {
                    PlanoContasDataGrid.SelectedItem = item;
                    PlanoContasDataGrid.ScrollIntoView(item);
                    PlanoContasDataGrid.Focus();
                    return;
                }
            }
            MessageBox.Show(string.Format("O Participante não foi encontrado."), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void UpdatePlanoContas(object sender, RoutedEventArgs e)
        {
            short r = 0;

            StatusBarLabel.Content = "Verificando arquivos...";

            #region Verificacoes
            NPCCTB npcctb = new NPCCTB();

            npcctb.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr");

            if ((r = npcctb.btrOpen(NPCCTB.OpenModes.Normal)) == 0)
            {
                npcctb.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas {0} não foi encontrado !", Properties.Settings.Default.PlanoContasAtual.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }
            else
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            npcctb.btrClose();

            if (!Directory.Exists(Properties.Settings.Default.GeralPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.GeralPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(Properties.Settings.Default.EmpresaPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.EmpresaPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (Properties.Settings.Default.PlanoContasAtual <= 0)
            {
                MessageBox.Show(string.Format("O código do Plano de Contas é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Error);
                return;
            }

            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"NPCCTB.btr")))
            {
                MessageBox.Show(string.Format("O arquivo com o cadastro de Plano de Contas em '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            #endregion

            #region Abertura de Arquivo
            // ***************************************** Open PlContas ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            PlContas plcontas = new PlContas();

            plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

            if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open DemoResu ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"DemoResu.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro de Demonstrativo de Resultado '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            DemoResu demoresu = new DemoResu();

            demoresu.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"DemoResu.btr");

            if ((r = demoresu.btrOpen(DemoResu.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"DemoResu.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            //***************************************** Open CFGPLREF ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"CFGPLREF.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro de Referencia SPED '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"CFGPLREF.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            CFGPLREF cfgplref = new CFGPLREF();

            cfgplref.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"CFGPLREF.btr");

            if ((r = cfgplref.btrOpen(CFGPLREF.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"CFGPLREF.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            //***************************************** Open FORANALI ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FORANALI foranali = new FORANALI();

            foranali.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath, EmpresaAtiva + @"\0\FORANALI.btr");

            if ((r = foranali.btrOpen(FORANALI.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open FornecA ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FornecA.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FornecA.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FornecA fornecA = new FornecA();

            fornecA.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath, EmpresaAtiva + @"\0\FornecA.btr");

            if ((r = fornecA.btrOpen(FornecA.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FornecA.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open FornecP ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FornecP.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FornecP.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FornecP fornecP = new FornecP();

            fornecP.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"FornecP.btr");

            if ((r = fornecP.btrOpen(FornecP.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FornecP.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open FORNEC ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNEC.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNEC.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FORNEC fornec = new FORNEC();

            fornec.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"FORNEC.btr");

            if ((r = fornec.btrOpen(FORNEC.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNEC.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open FornecG ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FornecG.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNEC.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FornecG fornecG = new FornecG();

            fornecG.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"FornecG.btr");

            if ((r = fornecG.btrOpen(FornecG.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FornecG.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open FORNECCT ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNECCT.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNECCT.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FORNECCT fornecct = new FORNECCT();

            fornecct.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"FORNECCT.btr");

            if ((r = fornecct.btrOpen(FORNECCT.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"FORNECCT.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open Notas ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro das Notas Fiscais '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            Notas notas = new Notas();

            notas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR");

            if ((r = notas.btrOpen(Notas.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Notas.BTR")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            //-----------------------------------------------------------------------------------------------------
            #endregion

            Encoding ansi = System.Text.Encoding.Default; // Encoding.GetEncoding(1252); // Encoding.GetEncoding(1252); // Encoding.GetEncoding("iso-8859-1");
            Encoding oem = Encoding.GetEncoding(CultureInfo.CurrentCulture.TextInfo.OEMCodePage); // Encoding.UTF8; // Encoding.GetEncoding(850); // Encoding.GetEncoding("us-ascii");

            //Stores the value of the ProgressBarCadastros
            double value = 0;

            //Create a new instance of our ProgressBarCadastros Delegate that points
            // to the ProgressBarCadastros's SetValue method.
            UpdateProgressBarCadastrosDelegate ProgressBarCadastrosDelegate =
                new UpdateProgressBarCadastrosDelegate(this.ProgressBarCadastros.SetValue);

            //UpdateProgressBarCadastrosDelegate ProgressLabelDelegate =
            //    new UpdateProgressBarCadastrosDelegate(this.ProgressLabel.SetValue);

            StatusBarLabel.Content = "";

            #region Processamento

            //Tight Loop: Loop until the ProgressBarCadastros.Value reaches the max
            try
            {

                MessageBoxResult msg = MessageBoxResult.No;

                #region Atualização do Plano de Contas

                if (PlanoContas.Where(x => x.Selecionado).Count() > 0)
                    msg = MessageBox.Show(string.Format("Confirma a atualização do Plano de Contas {0} no CONTMATIC ?", Properties.Settings.Default.PlanoContasAtual), "Altamira - Integracao Contabil", MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                if (msg == MessageBoxResult.Yes)
                {
                    if (PlanoContas.Where(x => x.Selecionado).Count() == 0)
                    {
                        MessageBox.Show("Nenhuma conta selecionada !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Exclamation);
                    }
                    else
                    {

                        //Configure the ProgressBarCadastros
                        this.ProgressBarCadastros.Minimum = 0;
                        this.ProgressBarCadastros.Maximum = PlanoContas.Where(x => x.Selecionado).Count();
                        this.ProgressBarCadastros.Value = 0;
                        StatusBarLabel.Content = "Atualizando Plano de Contas, aguarde...";
                        this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Visible;

                        foreach (ContaContabil c in PlanoContas.Where(x => x.Selecionado))
                        {
                            value += 1;

                            plcontas.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                            plcontas.Keys.idxindex_0.sgmConta = c.Conta.PadRight(56);

                            // Verifica se a Conta NÃO existe
                            if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_0, pvClientId)) == 4)
                            {
                                plcontas.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                plcontas.Keys.idxindex_1.sgmDescricao = c.Nome.PadRight(40);

                                //if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_1, pvClientId)) == 4)
                                //{
                                plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                plcontas.Keys.idxindex_2.sgmReduzida = c.Reduzida;

                                if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) == 4 || c.Reduzida == 0)
                                {
                                    //if ((r = plcontas.btrGetFirst(PlContas.KeyName.UK_Id, pvClientId)) == 0)
                                    //{
                                    //if ((r = lybtrcom.Session.BeginTrans()) == 0)
                                    //if ((r = lybtrcom.Session.BeginExclTrans(pvClientId)) == 0)
                                    //{
                                    //plcontas.Keys.idxindex_3.sgmIdPlano = Properties.Settings.Default.PlanoContas;
                                    //plcontas.Keys.idxUK_Id.sgmId = 0;

                                    byte nivel = 0;
                                    nivel += int.Parse(c.Conta.Trim().Substring(0, 1)) > 0 ? (byte)1 : (byte)0;
                                    nivel += int.Parse(c.Conta.Trim().Substring(2, 2)) > 0 ? (byte)1 : (byte)0;
                                    nivel += int.Parse(c.Conta.Trim().Substring(5, 2)) > 0 ? (byte)1 : (byte)0;
                                    nivel += int.Parse(c.Conta.Trim().Substring(8, 3)) > 0 ? (byte)1 : (byte)0;
                                    nivel += int.Parse(c.Conta.Trim().Substring(12, 5)) > 0 ? (byte)1 : (byte)0;

                                    plcontas.fldId = 0;
                                    plcontas.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    plcontas.Fields.fldConta = c.Conta.PadRight(56); // en.GetBytes(c.Conta).ToString();
                                    plcontas.Fields.fldDescricao = c.Nome.PadRight(40); // en.GetBytes(c.Descricao).ToString();
                                    plcontas.fldReduzida = c.Reduzida;
                                    plcontas.fldNivel = nivel;
                                    plcontas.fldunnamed_61 = " .  .  .   .     ".PadRight(56);
                                    plcontas.fldunnamed_62 = "".PadRight(34);

                                    if ((r = plcontas.btrInsert(PlContas.KeyName.NoCurrencyChange, pvClientId)) != 0)
                                    {
                                        //lybtrcom.Session.AbortTrans(/*pvClientId*/);
                                        //lybtrcom.Session.Reset(/*pvClientId*/);

                                        c.Situacao = "*** ERRO ***";
                                        c.Selecionado = false;

                                        MessageBox.Show(string.Format("Inclusão cancelada. Ocorreu um erro durante a atualização do Plano de Contas. O código do erro é {0}.", r), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                                        break;
                                    }
                                    else
                                    {
                                        //if ((r = lybtrcom.Session.EndTrans(/*pvClientId*/)) == 0)
                                        //{
                                        c.Situacao = "Conta Incluida";
                                        c.Selecionado = false;

                                        //}
                                        //else
                                        //{
                                        //    c.Situacao = "Erro BTRIEVE";
                                        //}
                                        //ybtrcom.Session.Reset(/*pvClientId*/);

                                        try
                                        {
                                            //Service.PlanoContasClient plclient = new Service.PlanoContasClient();

                                            //plclient.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                                            //plclient.Open();

                                            //plclient.Update(c.Conta);

                                            //plclient.Close();

                                        }
                                        catch (Exception ex1)
                                        {
                                            if (MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}\n\nDeseja continuar ?", Properties.Settings.Default.WebServiceURL, ex1.Message, ex1.InnerException != null ? ex1.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                    //}
                                    //else
                                    //{
                                    //    c.Situacao = "Erro BTRIEVE";
                                    //    MessageBox.Show(string.Format("Erro ao iniciar a operação de gravação. O código do erro é {0}."));
                                    //    break;
                                    //}
                                    //}
                                }
                                else
                                {
                                    c.Situacao = "Conta Reduzida Duplicada";
                                    if (MessageBox.Show(string.Format("Aviso: A Conta Reduzida:\n\n{0}\n{1}\n{2}\n\njá esta cadastrada no Plano de Contas {3}.\n\nPara evitar duplicidade esta conta não será incluida novamente.\nPara continuar inserindo as outras contas selecionadas clique OK ou clique CANCELAR para parar.", c.Reduzida.ToString(), c.Conta.Trim(), c.Nome.Trim(), Properties.Settings.Default.PlanoContasAtual.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Exclamation) == MessageBoxResult.Cancel)
                                        break;
                                }
                                //}
                                //else
                                //{
                                //    c.Situacao = "Descrição Duplicada";
                                //    if (MessageBox.Show(string.Format("Aviso: A Descrição da Conta:\n\n{0}\n{1}\n\njá esta cadastrada no Plano de Contas {2}.\n\nPara evitar duplicidade esta conta não será incluida novamente.\nPara continuar inserindo as outras contas selecionadas clique OK ou clique CANCELAR para parar.", c.Conta.Trim(), c.Nome.Trim(), Properties.Settings.Default.PlanoContas.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Exclamation) == MessageBoxResult.Cancel)
                                //        break;
                                //}
                            }
                            else
                            {
                                byte nivel = 0;
                                nivel += int.Parse(c.Conta.Trim().Substring(0, 1)) > 0 ? (byte)1 : (byte)0;
                                nivel += int.Parse(c.Conta.Trim().Substring(2, 2)) > 0 ? (byte)1 : (byte)0;
                                nivel += int.Parse(c.Conta.Trim().Substring(5, 2)) > 0 ? (byte)1 : (byte)0;
                                nivel += int.Parse(c.Conta.Trim().Substring(8, 3)) > 0 ? (byte)1 : (byte)0;
                                nivel += int.Parse(c.Conta.Trim().Substring(12, 5)) > 0 ? (byte)1 : (byte)0;

                                //plcontas.Fields.fldDescricao = encus.GetString(encpt.GetBytes(c.Nome.PadRight(40))); // en.GetBytes(c.Descricao).ToString();
                                plcontas.Fields.fldDescricao = c.Nome.PadRight(40); // oem.GetString(Encoding.Convert(ansi, oem, ansi.GetBytes(c.Nome.PadRight(40))));
                                plcontas.fldNivel = nivel;

                                if ((r = plcontas.btrUpdate(PlContas.KeyName.NoCurrencyChange, pvClientId)) != 0)
                                {
                                    if (MessageBox.Show(string.Format("Erro ao atualizar o Plano de Contas em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.Conta, c.Nome, plcontas.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                        break;
                                }

                                c.Situacao = "Conta Atualizada";
                                c.Selecionado = false;

                                //if (MessageBox.Show(string.Format("Aviso: A Conta:\n\n{0}\n{1}\n\njá esta cadastrada no Plano de Contas {2}.\n\nPara evitar duplicidade esta conta não será incluida novamente.\nPara continuar inserindo as outras contas selecionadas clique OK ou clique CANCELAR para parar.", c.Conta.Trim(), c.Nome.Trim(), Properties.Settings.Default.PlanoContas.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Exclamation) == MessageBoxResult.Cancel)
                                //    break;
                            }

                            // **************************** PLANO DE CONTAS REFERENCIA SPED *******************************************
                            if (c.ContaAntiga.Trim().Length > 0)
                            {
                                demoresu.Keys.idxindex_3.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                demoresu.Keys.idxindex_3.sgmConta = c.Conta.PadRight(56);

                                if ((r = demoresu.btrGetEqual(DemoResu.KeyName.index_3, pvClientId)) == 4) // nao existe a Conta nova
                                {
                                    demoresu.Keys.idxindex_3.sgmIdPlano = Properties.Settings.Default.PlanoContasAnterior;
                                    demoresu.Keys.idxindex_3.sgmConta = c.ContaAntiga.PadRight(56);

                                    if ((r = demoresu.btrGetEqual(DemoResu.KeyName.index_3, pvClientId)) == 0) // existe a Conta antiga
                                    {
                                        demoresu.Id = 0;
                                        demoresu.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        demoresu.fldConta = c.Conta.PadRight(56);

                                        if ((r = demoresu.btrInsert(DemoResu.KeyName.index_3, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o Demonstrativo de Resultado em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.Conta, c.Nome, cfgplref.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                }
                            }

                            if (c.ContaAntiga.Trim().Length > 0)
                            {
                                /*
                                cfgplref.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAnterior;
                                cfgplref.Keys.idxindex_0.sgmContaContabil = c.ContaAntiga.PadRight(56);
                                cfgplref.Keys.idxindex_0.sgmContaSPED = 0;

                                if ((r = cfgplref.btrGetEqual(CFGPLREF.KeyName.index_0, pvClientId)) == 0)
                                {
                                    do
                                    {
                                        if (cfgplref.fldIdPlano == Properties.Settings.Default.PlanoContasAnterior &&
                                            cfgplref.fldContaContabil.Trim() == c.ContaAntiga.Trim())
                                        {
                                            int sped = cfgplref.fldContaSPED;

                                            cfgplref.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                            cfgplref.Keys.idxindex_0.sgmContaContabil = c.Conta.PadRight(56);
                                            cfgplref.Keys.idxindex_0.sgmContaSPED = sped;

                                            if ((r = cfgplref.btrGetEqual(CFGPLREF.KeyName.index_0, pvClientId)) == 4)
                                            {
                                                cfgplref.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                                cfgplref.fldContaContabil = c.Conta.PadRight(56);
                                                cfgplref.fldContaSPED = sped;

                                                if ((r = cfgplref.btrInsert(CFGPLREF.KeyName.index_0, pvClientId)) != 0)
                                                {
                                                    if (MessageBox.Show(string.Format("Erro ao atualizar o Plano Referencial SPED em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.Conta, c.Nome, cfgplref.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                        break;
                                                }
                                            }
                                        }

                                    } while ((r = cfgplref.btrGetNext(CFGPLREF.KeyName.index_0, pvClientId)) == 0);
                                }
                                */
                            }
                            else
                            {
                                if (c.Tipo == "CL")
                                {
                                    cfgplref.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    cfgplref.Keys.idxindex_0.sgmContaContabil = c.Conta.PadRight(56);
                                    cfgplref.Keys.idxindex_0.sgmContaSPED = 22; // 1.01.05.02.00 - Cliente

                                    if ((r = cfgplref.btrGetEqual(CFGPLREF.KeyName.index_0, pvClientId)) == 4)
                                    {
                                        cfgplref.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        cfgplref.fldContaContabil = c.Conta.PadRight(56);
                                        cfgplref.fldContaSPED = 22;

                                        if ((r = cfgplref.btrInsert(CFGPLREF.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o Plano Referencial SPED em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.Conta, c.Nome, cfgplref.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                }

                                if (c.Tipo == "FO")
                                {
                                    cfgplref.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    cfgplref.Keys.idxindex_0.sgmContaContabil = c.Conta.PadRight(56);
                                    cfgplref.Keys.idxindex_0.sgmContaSPED = 76; // 2.01.01.01.00 - Fornecedor

                                    if ((r = cfgplref.btrGetEqual(CFGPLREF.KeyName.index_0, pvClientId)) == 4)
                                    {
                                        cfgplref.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        cfgplref.fldContaContabil = c.Conta.PadRight(56);
                                        cfgplref.fldContaSPED = 76;

                                        if ((r = cfgplref.btrInsert(CFGPLREF.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o Plano Referencial SPED em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.Conta, c.Nome, cfgplref.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }

                                    }
                                }
                            }

                            Dispatcher.Invoke(ProgressBarCadastrosDelegate,
                                System.Windows.Threading.DispatcherPriority.Background,
                                new object[] { ProgressBar.ValueProperty, value });
                        }
                        StatusBarLabel.Content = "";
                    }
                }
                #endregion

                #region Atualiza Cadastro Participantes
                if (msg != MessageBoxResult.Cancel)
                {

                    msg = MessageBoxResult.No;

                    if (Participantes.Where(x => x.Selecionado).Count() > 0)
                        msg = MessageBox.Show("Confirma a atualização do Cadastro de Participantes do CONTMATIC ?", "Altamira - Integracao Contabil", MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                    if (msg == MessageBoxResult.Yes)
                    {
                        if (Participantes.Where(x => x.Selecionado).Count() == 0)
                        {
                            MessageBox.Show("Nenhuma participante selecionado !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Exclamation);
                        }
                        else
                        {                            
                            this.ProgressBarCadastros.Minimum = 0;
                            this.ProgressBarCadastros.Maximum = Participantes.Where(x => x.Selecionado).Count();
                            this.ProgressBarCadastros.Value = 0;
                            StatusBarLabel.Content = "Atualizando Cadastro de Participantes, aguarde...";
                            this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Visible;

                            value = 0;

                            foreach (Participante c in Participantes.Where(x => x.Selecionado))
                            {
                                string cnpj = c.CNPJ.Trim();

                                value += 1;

                                if (cnpj.Trim().Length < 5)
                                {
                                    int n = 0;
                                    int.TryParse(cnpj.Trim(), out n);
                                    cnpj = String.Format(@"{0:00\.000\.000\/0000\-00}", n);
                                }

                                //if (c.CNPJ.Trim().Length == 0)
                                //    continue;

                                //if (c.CNPJ.Trim().Length == 14)
                                //{
                                //    cnpj = c.CNPJ.Substring(0, 2) + "." + c.CNPJ.Substring(2, 3) + "." + c.CNPJ.Substring(5, 3) + "/" + c.CNPJ.Substring(8, 4) + "-" + c.CNPJ.Substring(12, 2);
                                //}
                                //else
                                //{
                                //    MessageBox.Show(string.Format("Formato de CNPJ inválido [{0}].", c.CNPJ.Trim()));
                                //    break;
                                //}

                                // *********************** EMPRESAS\ALTAMIRA\0\FORNANALI.BT **********************************
                                bool insert = true;

                                //if (c.Tipo == "CL" || c.Tipo == "CF")
                                //{
                                    foranali.Keys.keyindex_0.sgmCNPJ = cnpj;
                                    foranali.Keys.keyindex_0.sgmClassificacao = "C";

                                    if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                                    {
                                        foranali.fldContaContabil = "".PadRight(56);

                                        if (c.Tipo == "CL" || c.Tipo == "CF")
                                            foranali.fldContaContabil = c.CCCliente.PadRight(56);

                                        foranali.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = foranali.btrUpdate(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    else
                                    {
                                        foranali.Keys.keyindex_1.sgmRazaoSocial = c.Nome;
                                        foranali.Keys.keyindex_1.sgmClassificacao = "C";

                                        if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                        {
                                            foranali.fldContaContabil = "".PadRight(56);

                                            if (c.Tipo == "CL" || c.Tipo == "CF")
                                                foranali.fldContaContabil = c.CCCliente.PadRight(56);

                                            if ((r = foranali.btrUpdate(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                            {
                                                if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                    break;
                                            }
                                            insert = false;
                                        }
                                    }

                                    if (insert)
                                    {
                                        foranali.fldId = 0;
                                        foranali.fldCNPJ = cnpj.PadRight(21);
                                        foranali.fldRazaoSocial = c.Nome.PadRight(48);
                                        foranali.fldClassificacao = "C";
                                        foranali.fldContaContabil = c.CCCliente.PadRight(56);

                                        if ((r = foranali.btrInsert(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                //if (c.Tipo == "FO" || c.Tipo == "CF")
                                //{
                                    foranali.Keys.keyindex_0.sgmCNPJ = cnpj;
                                    foranali.Keys.keyindex_0.sgmClassificacao = "F";

                                    if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                                    {
                                        foranali.fldContaContabil = "".PadRight(56);

                                        if (c.Tipo == "FO" || c.Tipo == "CF")
                                            foranali.fldContaContabil = c.CCFornecedor.PadRight(56);

                                        foranali.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = foranali.btrUpdate(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    else
                                    {
                                        foranali.Keys.keyindex_1.sgmRazaoSocial = c.Nome;
                                        foranali.Keys.keyindex_1.sgmClassificacao = "F";

                                        if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                        {
                                            foranali.fldContaContabil = "".PadRight(56);

                                            if (c.Tipo == "FO" || c.Tipo == "CF")
                                                foranali.fldContaContabil = c.CCFornecedor.PadRight(56);

                                            if ((r = foranali.btrUpdate(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                            {
                                                if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                    break;
                                            }
                                            insert = false;
                                        }
                                    }

                                    if (insert)
                                    {
                                        foranali.fldId = 0;
                                        foranali.fldCNPJ = cnpj.PadRight(21);
                                        foranali.fldRazaoSocial = c.Nome.PadRight(48);
                                        foranali.fldClassificacao = "F";
                                        foranali.fldContaContabil = c.CCFornecedor.PadRight(56);

                                        if ((r = foranali.btrInsert(FORANALI.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, foranali.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                fornecA.Keys.keyindex_0.sgmCNPJ = cnpj;
                                fornecA.Keys.keyindex_1.sgmRazaoSocial = c.Nome;

                                if ((r = fornecA.btrGetEqual(FornecA.KeyName.index_0, pvClientId)) == 0 ||
                                    (r = fornecA.btrGetEqual(FornecA.KeyName.index_1, pvClientId)) == 0)
                                {
                                    fornecA.fldContaContabilC = "".PadRight(25);
                                    fornecA.fldContaContabilF = "".PadRight(25);

                                    if (c.Tipo == "CL" || c.Tipo == "CF")
                                        fornecA.fldContaContabilC = c.CCCliente.PadRight(25);

                                    if (c.Tipo == "FO" || c.Tipo == "CF")
                                        fornecA.fldContaContabilF = c.CCFornecedor.PadRight(25);

                                    fornecA.fldRazaoSocial = c.Nome.PadRight(60);

                                    if ((r = fornecA.btrUpdate(FornecA.KeyName.index_0, pvClientId)) != 0)
                                    {
                                        if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {4}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n{3}\n\nDeseja continuar ?", r, c.CCCliente, c.CCFornecedor, c.Nome, fornecA.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                            break;
                                    }
                                    insert = false;
                                }

                                if (insert)
                                {
                                    fornecA.fldCNPJ = cnpj.PadRight(21);
                                    fornecA.fldRazaoSocial = c.Nome.PadRight(60);

                                    fornecA.fldContaContabilC = "".PadRight(25);
                                    fornecA.fldContaContabilF = "".PadRight(25);

                                    if (c.Tipo == "CL" || c.Tipo == "CF")
                                        fornecA.fldContaContabilC = c.CCCliente.PadRight(25);

                                    if (c.Tipo == "FO" || c.Tipo == "CF")
                                        fornecA.fldContaContabilF = c.CCFornecedor.PadRight(25);

                                    if ((r = fornecA.btrInsert(FornecA.KeyName.index_0, pvClientId)) != 0)
                                    {
                                        if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {4}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n{3}\n\nDeseja continuar ?", r, c.CCCliente, c.CCFornecedor, c.Nome, fornecA.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                            break;
                                    }
                                }

                                // ************************ GERAL ********************************************
                                insert = true;

                                //if (c.Tipo == "CL" || c.Tipo == "CF")
                                //{
                                    fornec.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);
                                    fornec.Keys.idxindex_0.sgmClassificacao = "C";

                                    if ((r = fornec.btrGetEqual(FORNEC.KeyName.index_0, pvClientId)) == 0)
                                    {
                                        fornec.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = fornec.btrUpdate(FORNEC.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    //else
                                    //{
                                    //    fornec.Keys.idxindex_1.sgmRazaoSocial = c.Nome.PadRight(40);
                                    //    fornec.Keys.idxindex_1.sgmClassificacao = "C";

                                    //    if ((r = fornec.btrGetEqual(FORNEC.KeyName.index_1, pvClientId)) == 0)
                                    //    {
                                    //        if ((r = fornec.btrUpdate(FORNEC.KeyName.index_1, pvClientId)) != 0)
                                    //        {
                                    //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                    //                break;
                                    //        }
                                    //        insert = false;
                                    //    }
                                    //}

                                    if (insert)
                                    {
                                        fornec.fldId = 0;
                                        fornec.fldCNPJ = cnpj.PadRight(21);
                                        fornec.fldRazaoSocial = c.Nome.PadRight(48);
                                        fornec.fldClassificacao = "C";
                                        fornec.fldCEP = "";
                                        fornec.fldCidade = "";
                                        fornec.fldEndereco = "";
                                        fornec.fldEstado = "";
                                        fornec.fldInscricaoEstadual = "";
                                        fornec.fldMunicipio = "";
                                        fornec.fldReservado2 = "";
                                        fornec.fldReservado3 = "";
                                        fornec.fldReservado5 = "";
                                        fornec.fldReservado6 = "";

                                        if ((r = fornec.btrInsert(FORNEC.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                //if (c.Tipo == "FO" || c.Tipo == "CF")
                                //{
                                    fornec.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);
                                    fornec.Keys.idxindex_0.sgmClassificacao = "F";

                                    if ((r = fornec.btrGetEqual(FORNEC.KeyName.index_0, pvClientId)) == 0)
                                    {
                                        fornec.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = fornec.btrUpdate(FORNEC.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    //else
                                    //{
                                    //    fornec.Keys.idxindex_1.sgmRazaoSocial = c.Nome;
                                    //    fornec.Keys.idxindex_1.sgmClassificacao = "F";

                                    //    if ((r = fornec.btrGetEqual(FORNEC.KeyName.index_1, pvClientId)) == 0)
                                    //    {
                                    //        if ((r = fornec.btrUpdate(FORNEC.KeyName.index_1, pvClientId)) != 0)
                                    //        {
                                    //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                    //                break;
                                    //        }
                                    //        insert = false;
                                    //    }
                                    //}

                                    if (insert)
                                    {
                                        fornec.fldId = 0;
                                        fornec.fldCNPJ = cnpj.PadRight(21);
                                        fornec.fldRazaoSocial = c.Nome.PadRight(48);
                                        fornec.fldClassificacao = "F";
                                        fornec.fldCEP = "";
                                        fornec.fldCidade = "";
                                        fornec.fldEndereco = "";
                                        fornec.fldEstado = "";
                                        fornec.fldInscricaoEstadual = "";
                                        fornec.fldMunicipio = "";
                                        fornec.fldReservado2 = "";
                                        fornec.fldReservado3 = "";
                                        fornec.fldReservado5 = "";
                                        fornec.fldReservado6 = "";

                                        if ((r = fornec.btrInsert(FORNEC.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornec.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                //if (c.Tipo == "CL" || c.Tipo == "CF")
                                //{
                                    fornecP.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    fornecP.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);

                                    if ((r = fornecP.btrGetEqual(FornecP.KeyName.index_0, pvClientId)) == 0) // existe
                                    {
                                        fornecP.fldContaContabilC = "".PadRight(25);
                                        fornecP.fldContaContabilF = "".PadRight(25);

                                        if (c.Tipo == "CL" || c.Tipo == "CF")
                                            fornecP.fldContaContabilC = c.CCCliente.PadRight(25);

                                        if (c.Tipo == "FO" || c.Tipo == "CF")
                                            fornecP.fldContaContabilF = c.CCFornecedor.PadRight(25);

                                        fornecP.fldRazaoSocial = c.Nome.PadRight(60);

                                        if ((r = fornecP.btrUpdate(FornecP.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    else
                                    {
                                        fornecP.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        fornecP.Keys.idxindex_1.sgmRazaoSocial = c.Nome.PadRight(60);

                                        if ((r = fornecP.btrGetEqual(FornecP.KeyName.index_1, pvClientId)) == 0) // existe
                                        {
                                            fornecP.fldContaContabilC = "".PadRight(25);
                                            fornecP.fldContaContabilF = "".PadRight(25);

                                            if (c.Tipo == "CL" || c.Tipo == "CF")
                                                fornecP.fldContaContabilC = c.CCCliente.PadRight(25);

                                            if (c.Tipo == "FO" || c.Tipo == "CF")
                                                fornecP.fldContaContabilF = c.CCFornecedor.PadRight(25);

                                            fornecP.fldRazaoSocial = c.Nome.PadRight(60);

                                            if ((r = fornecP.btrUpdate(FornecP.KeyName.index_1, pvClientId)) != 0)
                                            {
                                                if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                    break;
                                            }
                                            insert = false;
                                        }
                                    }

                                    if (insert)  // não existe
                                    {
                                        fornecP.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        fornecP.fldCNPJ = cnpj.PadRight(21);
                                        fornecP.fldRazaoSocial = c.Nome.PadRight(60);
                                        if (c.Tipo == "CL" || c.Tipo == "CF")
                                            fornecP.fldContaContabilC = c.CCCliente.PadRight(25);
                                        else
                                            fornecP.fldContaContabilC = "".PadRight(25);

                                        if (c.Tipo == "FO" || c.Tipo == "CF")
                                            fornecP.fldContaContabilF = c.CCFornecedor.PadRight(25);
                                        else
                                            fornecP.fldContaContabilF = "";
                                        fornecP.fldBairro = "";
                                        fornecP.fldEstado = "";
                                        fornecP.fldCEP = "";
                                        fornecP.fldCidade = "";
                                        fornecP.fldComplemento = "";
                                        fornecP.fldEmail = "";
                                        fornecP.fldEmailTail = "";
                                        fornecP.fldEndereco = "";
                                        fornecP.fldInscricaoEstadual = "";
                                        fornecP.fldInscricaoMunicipal = "";
                                        fornecP.fldMunicipio = "";
                                        fornecP.fldNumero = "";
                                        fornecP.fldPais = "";
                                        fornecP.fldSuframa = "";
                                        fornecP.fldTelefone = "";
                                        fornecP.fldunnamed_18 = "";
                                        fornecP.fldunnamed_20 = "";
                                        fornecP.fldunnamed_22 = "";
                                        fornecP.fldunnamed_46 = "";
                                        fornecP.fldunnamed_70 = "";

                                        if ((r = fornecP.btrInsert(FornecP.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                /*insert = true;

                                if (c.Tipo == "FO" || c.Tipo == "CF")
                                {
                                    fornecP.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    fornecP.Keys.idxindex_0.sgmCNPJ = cnpj;

                                    if ((r = fornecP.btrGetEqual(FornecP.KeyName.index_0, pvClientId)) == 0) // existe
                                    {
                                        fornecP.fldContaContabilF = c.CCFornecedor.PadRight(56);
                                        fornecP.fldRazaoSocial = c.Nome;

                                        if ((r = fornecP.btrUpdate(FornecP.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    //else
                                    //{
                                    //    fornecP.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    //    fornecP.Keys.idxindex_1.sgmRazaoSocial = c.Nome;

                                    //    if ((r = fornecP.btrGetEqual(FornecP.KeyName.index_1, pvClientId)) == 0) // existe
                                    //    {
                                    //        fornecP.fldContaContabilF = c.CCFornecedor.PadRight(56);

                                    //        if ((r = fornecP.btrUpdate(FornecP.KeyName.index_1, pvClientId)) != 0)
                                    //        {
                                    //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                    //                break;
                                    //        }
                                    //        insert = false;
                                    //    }
                                    //}

                                    if (insert)  // não existe
                                    {
                                        fornecP.fldCNPJ = cnpj;
                                        fornecP.fldRazaoSocial = c.Nome;
                                        fornecP.fldContaContabilF = c.CCFornecedor.PadRight(56);  // Cliente
                                        fornecP.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        fornecP.fldBairro = "";
                                        fornecP.fldEstado = "";
                                        fornecP.fldCEP = "";
                                        fornecP.fldCidade = "";
                                        fornecP.fldComplemento = "";
                                        fornecP.fldEmail = "";
                                        fornecP.fldEmailTail = "";
                                        fornecP.fldEndereco = "";
                                        fornecP.fldInscricaoEstadual = "";
                                        fornecP.fldInscricaoMunicipal = "";
                                        fornecP.fldMunicipio = "";
                                        fornecP.fldNumero = "";
                                        fornecP.fldPais = "";
                                        fornecP.fldSuframa = "";
                                        fornecP.fldTelefone = "";
                                        fornecP.fldunnamed_18 = "";
                                        fornecP.fldunnamed_20 = "";
                                        fornecP.fldunnamed_22 = "";
                                        fornecP.fldunnamed_46 = "";
                                        fornecP.fldunnamed_70 = "";

                                        if ((r = fornecP.btrInsert(FornecP.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecP.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                }*/

                                insert = true;

                                //if (c.Tipo == "CL" || c.Tipo == "CF")
                                //{
                                    fornecct.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    fornecct.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);
                                    fornecct.Keys.idxindex_0.sgmClassificacao = "C";

                                    if ((r = fornecct.btrGetEqual(FORNECCT.KeyName.index_0, pvClientId)) == 0) // existe
                                    {
                                        fornecct.fldContaContabil = "".PadRight(56);

                                        if (c.Tipo == "CL" || c.Tipo == "CF")
                                            fornecct.fldContaContabil = c.CCCliente.PadRight(56);

                                        fornecct.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = fornecct.btrUpdate(FORNECCT.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    //else
                                    //{
                                    //    fornecct.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    //    fornecct.Keys.idxindex_1.sgmRazaoSocial = c.Nome;
                                    //    fornecct.Keys.idxindex_1.sgmClassificacao = "C";

                                    //    if ((r = fornecct.btrGetEqual(FORNECCT.KeyName.index_1, pvClientId)) == 0) // existe
                                    //    {
                                    //        if ((r = fornecct.btrUpdate(FORNECCT.KeyName.index_1, pvClientId)) != 0)
                                    //        {
                                    //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                    //                break;
                                    //        }
                                    //        insert = false;
                                    //    }
                                    //}

                                    if (insert)  // não existe
                                    {
                                        fornecct.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        fornecct.fldCNPJ = cnpj.PadRight(21);
                                        fornecct.fldRazaoSocial = c.Nome.PadRight(48);
                                        fornecct.fldClassificacao = "C";
                                        if (c.Tipo == "CL" || c.Tipo == "CF")
                                            fornecct.fldContaContabil = c.CCCliente.PadRight(56);
                                        else
                                            fornecct.fldContaContabil = "".PadRight(56);
                                        fornecct.fldCEP = "";
                                        fornecct.fldCidade = "";
                                        fornecct.fldEndereco = "";
                                        fornecct.fldEstado = "";
                                        fornecct.fldIncricaoMunicipal = "";
                                        fornecct.fldInscricaoEstadual = "";
                                        fornecct.fldMunicipio = "";
                                        fornecct.fldReservado5 = "";
                                        fornecct.fldunnamed_14 = "";

                                        if ((r = fornecct.btrInsert(FORNECCT.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCCliente, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                //if (c.Tipo == "FO" || c.Tipo == "CF")
                                //{
                                    fornecct.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    fornecct.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);
                                    fornecct.Keys.idxindex_0.sgmClassificacao = "F";

                                    if ((r = fornecct.btrGetEqual(FORNECCT.KeyName.index_0, pvClientId)) == 0) // existe
                                    {
                                        fornecct.fldContaContabil = "".PadRight(56);

                                        if (c.Tipo == "FO" || c.Tipo == "CF")
                                            fornecct.fldContaContabil = c.CCFornecedor.PadRight(56);

                                        fornecct.fldRazaoSocial = c.Nome.PadRight(48);

                                        if ((r = fornecct.btrUpdate(FORNECCT.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                        insert = false;
                                    }
                                    //else
                                    //{
                                    //    fornecct.Keys.idxindex_1.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                    //    fornecct.Keys.idxindex_1.sgmRazaoSocial = c.Nome;
                                    //    fornecct.Keys.idxindex_1.sgmClassificacao = "F";

                                    //    if ((r = fornecct.btrGetEqual(FORNECCT.KeyName.index_1, pvClientId)) == 0) // existe
                                    //    {
                                    //        if ((r = fornecct.btrUpdate(FORNECCT.KeyName.index_1, pvClientId)) != 0)
                                    //        {
                                    //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                    //                break;
                                    //        }
                                    //        insert = false;
                                    //    }
                                    //}

                                    if (insert)  // não existe
                                    {
                                        fornecct.fldIdPlano = Properties.Settings.Default.PlanoContasAtual;
                                        fornecct.fldCNPJ = cnpj.PadRight(21);
                                        fornecct.fldRazaoSocial = c.Nome.PadRight(48);
                                        fornecct.fldClassificacao = "F";
                                        if (c.Tipo == "FO" || c.Tipo == "CF")
                                            fornecct.fldContaContabil = c.CCFornecedor.PadRight(56);
                                        else
                                            fornecct.fldContaContabil = "".PadRight(56);
                                        fornecct.fldCEP = "";
                                        fornecct.fldCidade = "";
                                        fornecct.fldEndereco = "";
                                        fornecct.fldEstado = "";
                                        fornecct.fldIncricaoMunicipal = "";
                                        fornecct.fldInscricaoEstadual = "";
                                        fornecct.fldMunicipio = "";
                                        fornecct.fldReservado5 = "";
                                        fornecct.fldunnamed_14 = "";

                                        if ((r = fornecct.btrInsert(FORNECCT.KeyName.index_0, pvClientId)) != 0)
                                        {
                                            if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n\n{1}\n{2}\n\nDeseja continuar ?", r, c.CCFornecedor, c.Nome, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                                break;
                                        }
                                    }
                                //}

                                insert = true;

                                fornecG.Keys.idxindex_0.sgmCNPJ = cnpj.PadRight(21);

                                if ((r = fornecG.btrGetEqual(FornecG.KeyName.index_0, pvClientId)) == 0) // existe
                                {
                                    fornecG.fldRazaoSocial = c.Nome.PadRight(60);

                                    if ((r = fornecG.btrUpdate(FornecG.KeyName.index_0, pvClientId)) != 0)
                                    {
                                        if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n{1}\n\nDeseja continuar ?", r, c.Nome, fornecG.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                            break;
                                    }
                                    insert = false;
                                }
                                //else
                                //{

                                //    fornecG.Keys.idxindex_1.sgmRazaoSocial = c.Nome;

                                //    if ((r = fornecG.btrGetEqual(FornecG.KeyName.index_1, pvClientId)) == 0) // existe
                                //    {
                                //        fornecG.fldRazaoSocial = c.Nome;

                                //        if ((r = fornecG.btrUpdate(FornecG.KeyName.index_1, pvClientId)) != 0)
                                //        {
                                //            if (MessageBox.Show(string.Format("Erro ao atualizar o cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n{1}\n\nDeseja continuar ?", r, c.Nome, fornecG.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                //                break;
                                //        }
                                //        insert = false;
                                //    }
                                //}

                                if (insert)  // não existe
                                {
                                    fornecG.fldCNPJ = cnpj.PadRight(21);
                                    fornecG.fldRazaoSocial = c.Nome.PadRight(60);
                                    fornecG.fldBairro = "";
                                    fornecG.fldEstado = "";
                                    fornecG.fldCEP = "";
                                    fornecG.fldCidade = "";
                                    fornecG.fldComplemento = "";
                                    fornecG.fldEmail = "";
                                    fornecG.fldEmailTail = "";
                                    fornecG.fldEndereco = "";
                                    fornecG.fldInscricaoEstadual = "";
                                    fornecG.fldInscricaoMunicipal = "";
                                    fornecG.fldMunicipio = "";
                                    fornecG.fldNumero = "";
                                    fornecG.fldPais = "";
                                    fornecG.fldSuframa = "";
                                    fornecG.fldTelefone = "";
                                    fornecG.fldReservado5 = "";
                                    fornecG.fldReservado7 = "";
                                    fornecG.fldReservado9 = "";
                                    fornecG.fldReservado11 = "";
                                    fornecG.fldunnamed_21 = "";

                                    if ((r = fornecG.btrInsert(FornecG.KeyName.index_0, pvClientId)) != 0)
                                    {
                                        if (MessageBox.Show(string.Format("Erro ao incluir no cadastro de Fornecedor em {3}.\nCódigo do Erro: {0}\n{2}\n\nDeseja continuar ?", r, c.Nome, fornecG.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                            break;
                                    }
                                }

                                c.Situacao = "Atualizado";

                                Dispatcher.Invoke(ProgressBarCadastrosDelegate,
                                    System.Windows.Threading.DispatcherPriority.Background,
                                    new object[] { ProgressBar.ValueProperty, value });

                                //Dispatcher.Invoke(ProgressLabelDelegate,
                                //    System.Windows.Threading.DispatcherPriority.Background,
                                //    new object[] { MyLabelProperty, string.Format("Processando {0}/{1}...", value, ProgressBarCadastros.Maximum) });
                            }
                            StatusBarLabel.Content = "";
                        }
                    }
                }
                #endregion

                #region Atualiza Conta Contabil Lancamentos de Notas Fiscais
                if (msg != MessageBoxResult.Cancel)
                {
                    msg = MessageBoxResult.No;

                    if (((List<NotaFiscal>)(NotasFiscaisDataGrid.ItemsSource)).Where(x => x.Selecionado).Count() > 0)
                        msg = MessageBox.Show("Confirma a atualização da Conta Contabil dos Lançamentos de Notas Fiscais ?", "Altamira - Integracao Contabil", MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                    if (msg == MessageBoxResult.Yes)
                    {
                        if (((List<NotaFiscal>)(NotasFiscaisDataGrid.ItemsSource)).Where(x => x.Selecionado).Count() == 0)
                        {
                            MessageBox.Show("Nenhuma Lançamento de Nota Fiscal selecionado !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Exclamation);
                        }
                        else
                        {
                            this.ProgressBarCadastros.Minimum = 0;
                            this.ProgressBarCadastros.Maximum = ((List<NotaFiscal>)(NotasFiscaisDataGrid.ItemsSource)).Where(x => x.Selecionado).Count();
                            this.ProgressBarCadastros.Value = 0;
                            StatusBarLabel.Content = "Atualizando Lançamento de Notas Fiscais, aguarde...";
                            this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Visible;

                            value = 0;

                            foreach (NotaFiscal n in ((List<NotaFiscal>)(NotasFiscaisDataGrid.ItemsSource)).Where(x => x.Selecionado))
                            {
                                value += 1;

                                if (n.NovaContaContabil == 0)
                                    continue;

                                notas.Keys.idxUK_Id.sgmId = n.Id;

                                if ((r = notas.btrGetEqual(Notas.KeyName.UK_Id, pvClientId)) == 0) // existe
                                {
                                    notas.fldContaContabil = n.NovaContaContabil.ToString().PadRight(12);

                                    if ((r = notas.btrUpdate(Notas.KeyName.UK_Id, pvClientId)) != 0)
                                    {
                                        if (MessageBox.Show(string.Format("Erro ao atualizar o Lançamento de Nota Fiscal em {4}.\nCódigo do Erro: {0}\n\nNumero: {1}\nOperacao: {2}\nCNPJ: {3}\n\nDeseja continuar ?", r, n.Numero, n.Operacao == "E" ? "Entrada" : "Saida", n.CNPJ, fornecct.DataPath), "Altamira - Integracao Contabil", MessageBoxButton.YesNo, MessageBoxImage.Error) == MessageBoxResult.No)
                                            break;
                                    }
                                }

                                n.Situacao = "Atualizado";
                                n.Selecionado = false;

                                Dispatcher.Invoke(ProgressBarCadastrosDelegate,
                                    System.Windows.Threading.DispatcherPriority.Background,
                                    new object[] { ProgressBar.ValueProperty, value });

                                //Dispatcher.Invoke(ProgressLabelDelegate,
                                //    System.Windows.Threading.DispatcherPriority.Background,
                                //    new object[] { MyLabelProperty, string.Format("Processando {0}/{1}...", value, ProgressBarCadastros.Maximum) });
                            }
                            StatusBarLabel.Content = "";
                        }
                    }
                }

                #endregion

                this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Hidden;

                if (msg != MessageBoxResult.Cancel)
                {
                    MessageBox.Show(string.Format("O Plano de Contas {0} foi atualizado com sucesso !", Properties.Settings.Default.PlanoContasAtual), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Information);
                }

            }
            catch (Exception ex2)
            {
                MessageBox.Show(string.Format("Ocorreu um erro ao atualizar o Plano de Contas.\n\nMensagem de erro: {0}\n{1}", ex2.Message, ex2.InnerException != null ? ex2.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            #endregion
            
            #region Fechamento de Arquivos
            plcontas.btrClose(pvClientId);
            demoresu.btrClose(pvClientId);
            fornecP.btrClose(pvClientId);
            fornecA.btrClose(pvClientId);
            fornecct.btrClose(pvClientId);
            fornec.btrClose(pvClientId);
            foranali.btrClose(pvClientId);
            fornecG.btrClose(pvClientId);
            cfgplref.btrClose(pvClientId);
            notas.btrClose(pvClientId);
            #endregion

            //this.Close();
        }

        private void ProcurarParticipanteButton(object sender, RoutedEventArgs e)
        {
            ParticipantesDataGrid.SelectedIndex = -1;
            ProcurarProximoParticipanteButton(sender, e);
        }

        private void ProcurarProximoParticipanteButton(object sender, RoutedEventArgs e)
        {
            for (int i = ParticipantesDataGrid.SelectedIndex == -1 ? 0 : ParticipantesDataGrid.SelectedIndex + 1; i < ParticipantesDataGrid.Items.Count; i++)
            {
                Participante item = (Participante)ParticipantesDataGrid.Items[i];

                if (item.Nome.Trim().ToLower().Contains(ProcurarParticipanteTextbox.Text.Trim().ToLower()) ||
                    item.CCFornecedor.Trim().ToLower().Contains(ProcurarParticipanteTextbox.Text.Trim().ToLower()) ||
                    item.CCCliente.Trim().ToLower().Contains(ProcurarParticipanteTextbox.Text.Trim().ToLower()) ||
                    item.CNPJ.Trim().ToLower().Contains(ProcurarParticipanteTextbox.Text.Trim().ToLower()))
                {
                    ParticipantesDataGrid.SelectedItem = item;
                    ParticipantesDataGrid.ScrollIntoView(item);
                    ParticipantesDataGrid.Focus();
                    return;
                }
            }

            MessageBox.Show(string.Format("O Participante não foi encontrado."), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void ProcurarProximaNotaFiscalButton(object sender, RoutedEventArgs e)
        {
            for (int i = NotasFiscaisDataGrid.SelectedIndex == -1 ? 0 : NotasFiscaisDataGrid.SelectedIndex + 1; i < NotasFiscaisDataGrid.Items.Count; i++)
            {
                NotaFiscal item = (NotaFiscal)NotasFiscaisDataGrid.Items[i];

                if (item.Numero.ToString().Trim().ToLower().Contains(ProcurarNotaFiscalTextbox.Text.Trim().ToLower()) ||
                    item.ContaContabil.ToString().ToLower().Contains(ProcurarNotaFiscalTextbox.Text.Trim().ToLower()) ||
                    item.CNPJ.Trim().ToLower().Contains(ProcurarNotaFiscalTextbox.Text.Trim().ToLower()))
                {
                    NotasFiscaisDataGrid.SelectedItem = item;
                    NotasFiscaisDataGrid.ScrollIntoView(item);
                    NotasFiscaisDataGrid.Focus();
                    return;
                }
            }

            MessageBox.Show(string.Format("A Nota Fiscal não foi encontrada."), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void ProcurarNotaFiscalButton(object sender, RoutedEventArgs e)
        {
            NotasFiscaisDataGrid.SelectedIndex = -1;
            ProcurarProximaNotaFiscalButton(sender, e);
        }

        private void ExportExcel(object sender, RoutedEventArgs e)
        {
            switch (IntegracaoTabControl.SelectedIndex)
            {
                case 1:
                    {
                        if (CadastrosTabControl.SelectedIndex == 0)
                        {
                            ExportToExcel<ContaContabil, List<ContaContabil>> s = new ExportToExcel<ContaContabil, List<ContaContabil>>();
                            s.dataToPrint = (List<ContaContabil>)PlanoContasDataGrid.ItemsSource;
                            s.GenerateReport();
                        }
                        else if (CadastrosTabControl.SelectedIndex == 1)
                        {
                            ExportToExcel<Participante, List<Participante>> s = new ExportToExcel<Participante, List<Participante>>();
                            s.dataToPrint = (List<Participante>)ParticipantesDataGrid.ItemsSource;
                            s.GenerateReport();
                        }
                        else if (CadastrosTabControl.SelectedIndex == 2)
                        {
                            ExportToExcel<NotaFiscal, List<NotaFiscal>> s = new ExportToExcel<NotaFiscal, List<NotaFiscal>>();
                            s.dataToPrint = (List<NotaFiscal>)NotasFiscaisDataGrid.ItemsSource;
                            s.GenerateReport();
                        }
                    }
                    break;
                case 0:
                    {
                        ExportToExcel<LancamentoFluxoCaixa, List<LancamentoFluxoCaixa>> s = new ExportToExcel<LancamentoFluxoCaixa, List<LancamentoFluxoCaixa>>();
                        s.dataToPrint = (List<LancamentoFluxoCaixa>)LancamentosFluxoCaixaDataGrid.ItemsSource;
                        s.GenerateReport();
                    }
                    break;
                default:
                    break;
            }
            

        }

        private void UpdateLancamentos(object sender, RoutedEventArgs e)
        {
            short r = 0;

            StatusBarLabel.Content = "Verificando arquivos...";

            #region Verificacoes
            NPCCTB npcctb = new NPCCTB();

            npcctb.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr");

            if ((r = npcctb.btrOpen(NPCCTB.OpenModes.Normal)) == 0)
            {
                npcctb.Keys.idxindex_0.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas {0} não foi encontrado !", Properties.Settings.Default.PlanoContasAtual.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }
            else
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            npcctb.btrClose();

            if (!Directory.Exists(Properties.Settings.Default.GeralPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.GeralPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(Properties.Settings.Default.EmpresaPath.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", Properties.Settings.Default.EmpresaPath.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (Properties.Settings.Default.PlanoContasAtual <= 0)
            {
                MessageBox.Show(string.Format("O código do Plano de Contas é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Error);
                return;
            }

            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"NPCCTB.btr")))
            {
                MessageBox.Show(string.Format("O arquivo com o cadastro de Plano de Contas em '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            #endregion

            #region Abertura de Arquivo
            // ***************************************** Open PlContas ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            PlContas plcontas = new PlContas();

            plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

            if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open HPADRAO ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro de Historico Padrão '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"HPADRAO.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            HPADRAO hpadrao = new HPADRAO();

            hpadrao.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr");

            if ((r = hpadrao.btrOpen(HPADRAO.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // ***************************************** Open Lctos ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Lctos.BTR")))
            {
                MessageBox.Show(string.Format("O arquivo de Lançamentos Contabeis '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Lctos.BTR")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            Lctos lctos = new Lctos();

            lctos.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Lctos.BTR");

            if ((r = lctos.btrOpen(Lctos.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"Lctos.BTR")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            //***************************************** Open FORANALI ******************************************
            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")))
            {
                MessageBox.Show(string.Format("O arquivo de cadastro do Fornecedores '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            FORANALI foranali = new FORANALI();

            foranali.DataPath = System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath, EmpresaAtiva + @"\0\FORANALI.btr");

            if ((r = foranali.btrOpen(FORANALI.OpenModes.Normal, pvClientId)) != 0)
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva + @"\0\FORANALI.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            //-----------------------------------------------------------------------------------------------------
            #endregion

            #region Verificacoes
            int CCRDebito = 0;
            int CCRCredito = 0;
            string CCDebito = "";
            string CCCredito = "";

            if (CCDebitoReduzidaTextBox.Text.Trim().Length == 0)
            {
                MessageBox.Show("A Conta de Debito não foi preenchida !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            else
            {
                int reduzida = 0;

                if (int.TryParse(CCDebitoReduzidaTextBox.Text.Trim(), out reduzida))
                {

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

                    if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                    plcontas.Keys.idxindex_2.sgmReduzida = reduzida;

                    // Verifica se a Conta existe
                    if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("A Conta de Debito {0} não foi encontrada !", reduzida), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }
                    else
                    {
                        CCRDebito = plcontas.fldReduzida;
                        CCDebito = plcontas.fldConta;
                    }
                }
                else
                {
                    //MessageBox.Show("A Conta de Debito é invalida !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    //return;
                }
            }

            if (CCCreditoReduzidaTextBox.Text.Trim().Length == 0)
            {
                MessageBox.Show("A Conta de Crédito não foi preenchida !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            else
            {
                int reduzida = 0;

                if (int.TryParse(CCCreditoReduzidaTextBox.Text.Trim(), out reduzida))
                {

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

                    if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                    plcontas.Keys.idxindex_2.sgmReduzida = reduzida;

                    // Verifica se a Conta existe
                    if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("A Conta de Credito {0} não foi encontrada !", reduzida), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }
                    else
                    {
                        CCRCredito = plcontas.fldReduzida;
                        CCCredito = plcontas.fldConta;
                    }
                }
                else
                {
                    //MessageBox.Show("A Conta de Crédito é invalida !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    //return;
                }
            }

            int HistoricoPadrao = 0;

            if (HistoricoCodigoTextBox.Text.Trim().Length == 0)
            {
                MessageBox.Show("O Código do Historico Padrão não foi preenchida !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            else
            {
                int historico = 0;

                if (int.TryParse(HistoricoCodigoTextBox.Text.Trim(), out historico))
                {

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro de Historico Padrão '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"HPADRAO.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    hpadrao.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr");

                    if ((r = hpadrao.btrOpen(HPADRAO.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    hpadrao.Keys.idxindex_0.sgmCodigo = historico;

                    // Verifica se a Conta existe
                    if ((r = hpadrao.btrGetEqual(HPADRAO.KeyName.index_0, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("O Código do Historico {0} não foi encontrada !", historico), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }
                    else
                    {
                        HistoricoPadrao = hpadrao.fldCodigo;
                    }
                }
                else
                {
                    MessageBox.Show("O Código do Historico é invalido !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }
            //Verificar o Historico

            #endregion

            //***************************************** Open ordem.seq ******************************************
            //if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"ordem.seq")))
            //{
            //    MessageBox.Show(string.Format("O arquivo de Sequencia dos Lançamentos Contabeis '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"ordem.seq")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            //    return;
            //}

            FileStream ordemfs = null;
            int Lancamento = 0;
            int Sequencia = 0;

            //try
            //{
            //    ordemfs = new FileStream(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"ordem.seq"), FileMode.Append, FileAccess.ReadWrite, FileShare.None);
            //}
            //catch
            //{
            //    MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"ordem.seq")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            //    return;
            //}

            //try
            //{
            //    TextReader seqtxt = new StreamReader(ordemfs);

            //    string line;

            //    if ((line = seqtxt.ReadLine()).Length > 0)
            //        Lancamento = int.Parse(line);

            //    if ((line = seqtxt.ReadLine()).Length > 0)
            //        Sequencia = int.Parse(line);

            //    //if (Lancamento != Sequencia)
            //    //{
            //    //    MessageBox.Show("A sequencia de lançamentos esta fora de ordem.", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            //    //    ordemfs.Close();
            //    //    return;
            //    //}

            //}
            //catch
            //{
            //    //MessageBox.Show("Ocorreu um erro ao ler o arquivo de Sequencia de Lançamentos Contabeis !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            //    //ordemfs.Close();
            //    //return;
            //    Lancamento = 0;
            //    Sequencia = 0;
            //}

            //Stores the value of the ProgressBarCadastros
            double value = 0;

            //Create a new instance of our ProgressBarCadastros Delegate that points
            // to the ProgressBarCadastros's SetValue method.
            UpdateProgressBarCadastrosDelegate ProgressBarCadastrosDelegate =
                new UpdateProgressBarCadastrosDelegate(this.ProgressBarCadastros.SetValue);

            //UpdateProgressBarCadastrosDelegate ProgressLabelDelegate =
            //    new UpdateProgressBarCadastrosDelegate(this.ProgressLabel.SetValue);

            StatusBarLabel.Content = "";
            
            #region Processamento

            //Tight Loop: Loop until the ProgressBarCadastros.Value reaches the max
            try
            {
                MessageBoxResult msg = MessageBoxResult.No;

                #region Atualiza Lançamentos Contabeis

                if (!((List<LancamentoFluxoCaixa>)(LancamentosFluxoCaixaDataGrid.ItemsSource)).Where(x => x.Selecionado).Any())
                    MessageBox.Show("Nenhuma Lançamento selecionado !", "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Exclamation);
                else
                    msg = MessageBox.Show("Confirma a atualização dos Lançamentos Contabeis ?", "Altamira - Integracao Contabil", MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                if (msg == MessageBoxResult.Yes)
                {

                    this.ProgressBarCadastros.Minimum = 0;
                    this.ProgressBarCadastros.Maximum = ((List<LancamentoFluxoCaixa>)(LancamentosFluxoCaixaDataGrid.ItemsSource)).Where(x => x.Selecionado).Count();
                    this.ProgressBarCadastros.Value = 0;
                    StatusBarLabel.Content = "Atualizando Lançamento Contabeis, aguarde...";
                    this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Visible;

                    value = 0;

                    foreach (LancamentoFluxoCaixa n in ((List<LancamentoFluxoCaixa>)(LancamentosFluxoCaixaDataGrid.ItemsSource)).Where(x => x.Selecionado))
                    {
                        value += 1;

                        if (n.Lancamento > 0)
                        {
                            MessageBoxResult msgresult = MessageBoxResult.Cancel;

                            if ((msgresult = MessageBox.Show(string.Format("Lançamento: {0}\nDocumento: {1}\nPagamento: {2}\nTitular: {3}\n\nJá foi carregado no CONTMATIC. Conta Debito: {4}, Conta Crédito: {5}\n\nClique SIM para lançar novamente (pode gerar duplicidade), clique NAO para continuar sem este lançamento ou CANCELAR para parar.", n.Lancamento, n.Documento, n.Pagamento, n.Titular, n.Debito, n.Credito), "Altamira - Integracao Contabil", MessageBoxButton.YesNoCancel, MessageBoxImage.Error)) == MessageBoxResult.Cancel)
                                break;
                            else if (msgresult == MessageBoxResult.No)
                                continue;

                        }

                        if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("CLIENTE") > -1)
                        {
                            foranali.Keys.keyindex_0.sgmCNPJ = n.CNPJ;
                            foranali.Keys.keyindex_0.sgmClassificacao = "C";

                            if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                            {
                                int.TryParse(foranali.fldContaContabil.Trim(), out CCRDebito);
                            }
                            else
                            {
                                foranali.Keys.keyindex_1.sgmRazaoSocial = n.Titular;
                                foranali.Keys.keyindex_1.sgmClassificacao = "C";

                                if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                {
                                    int.TryParse(foranali.fldContaContabil.Trim(), out CCRDebito);
                                }
                            }
                        }

                        if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("FORNECEDOR") > -1)
                        {
                            foranali.Keys.keyindex_0.sgmCNPJ = n.CNPJ;
                            foranali.Keys.keyindex_0.sgmClassificacao = "F";

                            if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                            {
                                int.TryParse(foranali.fldContaContabil.Trim(), out CCRDebito);
                            }
                            else
                            {
                                foranali.Keys.keyindex_1.sgmRazaoSocial = n.Titular;
                                foranali.Keys.keyindex_1.sgmClassificacao = "F";

                                if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                {
                                    int.TryParse(foranali.fldContaContabil.Trim(), out CCRDebito);
                                }
                            }
                        }

                        if (CCCreditoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("CLIENTE") > -1)
                        {
                            foranali.Keys.keyindex_0.sgmCNPJ = n.CNPJ;
                            foranali.Keys.keyindex_0.sgmClassificacao = "C";

                            if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                            {
                                int.TryParse(foranali.fldContaContabil.Trim(), out CCRCredito);
                            }
                            else
                            {
                                foranali.Keys.keyindex_1.sgmRazaoSocial = n.Titular;
                                foranali.Keys.keyindex_1.sgmClassificacao = "C";

                                if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                {
                                    int.TryParse(foranali.fldContaContabil.Trim(), out CCRCredito);
                                }
                            }
                        }

                        if (CCCreditoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("FORNECEDOR") > -1)
                        {
                            foranali.Keys.keyindex_0.sgmCNPJ = n.CNPJ;
                            foranali.Keys.keyindex_0.sgmClassificacao = "F";

                            if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_0, pvClientId)) == 0)
                            {
                                int.TryParse(foranali.fldContaContabil.Trim(), out CCRCredito);
                            }
                            else
                            {
                                foranali.Keys.keyindex_1.sgmRazaoSocial = n.Titular;
                                foranali.Keys.keyindex_1.sgmClassificacao = "F";

                                if ((r = foranali.btrGetEqual(FORANALI.KeyName.index_1, pvClientId)) == 0)
                                {
                                    int.TryParse(foranali.fldContaContabil.Trim(), out CCRCredito);
                                }
                            }
                        }

                        if (CCRDebito == 0)
                        {
                            if (MessageBox.Show(String.Format("A Conta de Debito {0} não foi encontrada !\n\n{1} - {2} - {3}\n\nClique OK para continuar.", CCDebitoReduzidaTextBox.Text, n.Documento, n.Pagamento.Value.ToShortDateString(), n.Titular.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Error) == MessageBoxResult.Cancel)
                                break;
                            else
                                continue;
                        }
                        else
                        {
                            plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                            plcontas.Keys.idxindex_2.sgmReduzida = CCRDebito;

                            // Verifica se a Conta existe
                            if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) == 0)
                            {
                                CCDebito = plcontas.fldConta;
                            }
                            else
                            {
                                MessageBox.Show(String.Format("A Conta de Debito {0} não foi encontrada !", CCCreditoReduzidaTextBox.Text), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                                break;
                            }
                        }

                        if (CCRCredito == 0)
                        {
                            if (MessageBox.Show(String.Format("A Conta de Credito {0} não foi encontrada !\n\n{1} - {2} - {3}\n\nClique OK para continuar.", CCCreditoReduzidaTextBox.Text, n.Documento, n.Pagamento.Value.ToShortDateString(), n.Titular.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Error) == MessageBoxResult.Cancel)
                                break;
                            else
                                continue;
                        }
                        else
                        {
                            plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                            plcontas.Keys.idxindex_2.sgmReduzida = CCRCredito;

                            // Verifica se a Conta existe
                            if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) == 0)
                            {
                                CCCredito = plcontas.fldConta;
                            }
                            else
                            {
                                MessageBox.Show(String.Format("A Conta de Credito {0} não foi encontrada !", CCCreditoReduzidaTextBox.Text), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                                break;
                            }
                        }

                        int id = 0;
                        if ((r = lctos.btrGetLast(Lctos.KeyName.UK_Id, pvClientId)) == 0)
                            id = lctos.fldId;
                        else
                            id = 1;

                        int lan = 0;
                        if ((r = lctos.btrGetLast(Lctos.KeyName.index_0, pvClientId)) == 0)
                            lan = lctos.fldLancamento;
                        else
                            lan = 1;

                        int seq = 0;

                        if ((r = lctos.btrGetLast(Lctos.KeyName.index_6, pvClientId)) == 0)
                            seq = lctos.fldSequencia;
                        else
                            seq = 1;

                        Lancamento = lan;
                        Sequencia = seq;

                        //if (lan != Lancamento || seq != Sequencia)
                        //{
                        //    MessageBoxResult result = MessageBoxResult.Cancel;

                        //    if ((result = MessageBox.Show(string.Format("Numeração dos Lançamentos fora de sequencia !\n\nId={0}, Lancamento={1}/{2}, Sequencia={3}/{4}.", id, lan, Lancamento, seq, Sequencia), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error)) == MessageBoxResult.Yes)
                        //    {
                        //        Lancamento = lan;
                        //        Sequencia = seq;
                        //    }
                        //    break;
                        //}

                        Lancamento++;
                        Sequencia++;

                        lctos.fldId = 0;
                        lctos.fldLancamento = Lancamento;
                        lctos.fldOrigem = "C"; // Contabil/Escrita Fiscal G5/Folha
                        lctos.fldLote = 0;
                        lctos.fldunnamed_4 = 0;
                        lctos.fldunnamed_5 = Lancamento;
                        lctos.fldunnamed_7 = "";
                        lctos.fldMes = (short)n.Pagamento.Value.Month;
                        lctos.fldDia = (short)n.Pagamento.Value.Day;
                        lctos.fldSequencia = Sequencia;
                        lctos.fldunnamed_234 = "C"; // C/D/<branco>
                        lctos.fldCCDebito = CCDebito;
                        lctos.fldCCCredito = CCCredito;
                        lctos.fldCCRDebito = CCRDebito.ToString(); 
                        lctos.fldCCRCredito = CCRCredito.ToString();

                        if (FaturamentoRadioButton.IsChecked.Value && !n.Faturamento.HasValue)
                        {
                            MessageBoxResult msgresult = MessageBoxResult.Cancel;

                            if ((msgresult = MessageBox.Show(string.Format("Documento: {0}\nPedido: {1}\nTitular: {2}\n\nA Data do Faturamento esta em branco.\n\nclique OK para continuar sem este lançamento ou CANCELAR para parar.", n.Documento, n.Pedido, n.Titular), "Altamira - Integracao Contabil", MessageBoxButton.OKCancel, MessageBoxImage.Error)) == MessageBoxResult.Cancel)
                                break;
                            else 
                                continue;
                        }

                        lctos.fldData = PagamentoRadioButton.IsChecked.HasValue && PagamentoRadioButton.IsChecked.Value ? string.Format("{0:dd/MM}", n.Pagamento.Value).Trim() : string.Format("{0:dd/MM}", n.Faturamento.Value).Trim();

                        lctos.fldValor = (double)n.ValorBaixa;
                        lctos.fldHistorico = HistoricoPadrao;
                        lctos.fldComplemento = HistoricoComplementoTextBox.Text.ToUpper()
                            .Replace("\"PEDIDO\"", n.Pedido)
                            .Replace("\"DOCUMENTO\"", n.Documento)
                            .Replace("\"PAGAMENTO\"", n.Pagamento.Value.ToShortDateString())
                            .Replace("\"VENCIMENTO\"", n.Vencimento.Value.ToShortDateString())
                            .Replace("\"CNPJ\"", n.CNPJ)
                            .Replace("\"TITULAR\"", n.Titular)
                            .Replace("\"VALOR\"", n.Valor.ToString())
                            .Replace("\"BANCO\"", n.Banco.ToString());

                        if ((r = lctos.btrInsert(Lctos.KeyName.UK_Id, pvClientId)) != 0)
                        {
                            MessageBox.Show(string.Format("Erro ao inserir Lançamento Contabil.\nCodigo do Erro: {0}.", r), "Altamira - Integração Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                            break;
                        }

                        if (r == 0)
                        {
                            ordemfs = new FileStream(System.IO.Path.Combine(Properties.Settings.Default.EmpresaPath.Trim(), EmpresaAtiva, AnoAtivo, @"ordem.seq"), FileMode.Create, FileAccess.ReadWrite, FileShare.None);
                            ordemfs.Seek(0, SeekOrigin.Begin);
                            TextWriter tr = new StreamWriter(ordemfs);
                            tr.WriteLine(Lancamento.ToString());
                            tr.WriteLine(Sequencia.ToString());
                            tr.Flush();
                            ordemfs.Flush();
                            ordemfs.Close();
                        }

                        //if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("CLIENTE") > -1 ||
                        //    CCDebitoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("FORNECEDOR") > -1 ||
                        //    CCCreditoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("CLIENTE") > -1 ||
                        //    CCCreditoReduzidaTextBox.Text.Trim().ToUpper().IndexOf("FORNECEDOR") > -1)
                        //{
                        //    CCRDebito = 0;
                        //    CCRCredito = 0;
                        //}

                        try
                        {
                            StatusBarLabel.Content = "Atualizando Fluxo de Caixa, aguarde...";

                            this.Cursor = Cursors.Wait;

                            Service.PlanoContasClient plClient = new Service.PlanoContasClient();

                            plClient.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                            plClient.Open();

                            bool result = plClient.LancamentosFluxoCaixaConciliado(n.Titulo, lctos.fldLancamento, lctos.fldSequencia, lctos.fldCCRDebito, lctos.fldCCRCredito);

                            plClient.Close();

                            this.Cursor = Cursors.Arrow;

                            StatusBarLabel.Content = "";
                        }
                        catch (Exception ex)
                        {
                            this.Cursor = Cursors.Arrow;

                            StatusBarLabel.Content = "";

                            MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}", Properties.Settings.Default.WebServiceURL, ex.Message, ex.InnerException != null ? ex.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                            break;
                        }

                        n.Situacao = "Atualizado";
                        n.Lancamento = lctos.fldLancamento;
                        n.Sequencia = lctos.fldSequencia;
                        n.Debito = lctos.fldCCRDebito;
                        n.Credito = lctos.fldCCRCredito;
                        n.Selecionado = false;

                        Dispatcher.Invoke(ProgressBarCadastrosDelegate,
                            System.Windows.Threading.DispatcherPriority.Background,
                            new object[] { ProgressBar.ValueProperty, value });

                        //Dispatcher.Invoke(ProgressLabelDelegate,
                        //    System.Windows.Threading.DispatcherPriority.Background,
                        //    new object[] { MyLabelProperty, string.Format("Processando {0}/{1}...", value, ProgressBarCadastros.Maximum) });
                    }
                    StatusBarLabel.Content = "";

                    this.ProgressBarCadastros.Visibility = System.Windows.Visibility.Hidden;

                    if (msg != MessageBoxResult.Cancel)
                    {
                        MessageBox.Show(string.Format("Os Lançamentos Contabeis foram atualizados com sucesso !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                }
                #endregion
            }
            catch (Exception ex2)
            {
                MessageBox.Show(string.Format("Ocorreu um erro ao incluir o Lançamento Contabil.\n\nMensagem de erro: {0}\n{1}", ex2.Message, ex2.InnerException != null ? ex2.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            #endregion

            #region Fechamento de Arquivos
            //ordemfs.Close();
            foranali.btrClose(pvClientId);
            lctos.btrClose(pvClientId);
            hpadrao.btrClose(pvClientId);
            plcontas.btrClose(pvClientId);
            #endregion

        }

        private void CarregarListaLancamentos(object sender, RoutedEventArgs e)
        {
            #region Carregando Lançamentos do Fluxo de Caixa

            Service.LancamentoFluxoCaixa[] LancamentosFluxoCaixaList;
           
            DateTime DataInicial, DataFinal;
            string Tipo, Filtro = "";
            int Data = 0;

            try
            {
                DataInicial = DateTime.Parse(DataInicialDatePicker.Text);
            }
            catch
            {
                MessageBox.Show("Data Inicial inválida !");
                return;
            }

            try
            {
                DataFinal = DateTime.Parse(DataFinalDatePicker.Text);
            }
            catch
            {
                MessageBox.Show("Data Final inválida !");
                return;
            }

            Tipo = PagarCheckBox.IsChecked == true ? "Pagar" : "";
            Tipo += ReceberCheckBox.IsChecked == true ? "Receber" : "";

            Filtro = FiltroTextBox.Text;

            if (TipoDataComboBox.Text == "Vencimento")
                Data = 1;
            else if (TipoDataComboBox.Text == "Pagamento")
                Data = 2;
            else if (TipoDataComboBox.Text == "Faturamento")
                Data = 3;

            try
            {
                StatusBarLabel.Content = "Carregando Lançamentos Contabeis, aguarde...";

                this.Cursor = Cursors.Wait;

                Service.PlanoContasClient plClient = new Service.PlanoContasClient();

                plClient.Endpoint.Address = new System.ServiceModel.EndpointAddress(Properties.Settings.Default.WebServiceURL);

                plClient.Open();

                LancamentosFluxoCaixaList = plClient.LancamentosFluxoCaixaList(Data, DataInicial, DataFinal, Tipo, OrigemComboBox.Text, ((ComboBoxItem)BancoComboBox.SelectedItem).Tag.ToString(), Filtro);

                plClient.Close();

                this.Cursor = Cursors.Arrow;

                StatusBarLabel.Content = "";
            }
            catch (Exception ex)
            {
                this.Cursor = Cursors.Arrow;

                StatusBarLabel.Content = "";

                MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nMensagem de erro: {1}\n\n{2}", Properties.Settings.Default.WebServiceURL, ex.Message, ex.InnerException != null ? ex.InnerException.Message : ""), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            //PlanoContas = (from i in ContaContabilList //query
            //               select new ContaContabil()
            //               {
            //                   Conta = i.Conta,
            //                   ContaAntiga = i.ContaAntiga,
            //                   CNPJ = i.CNPJ,
            //                   Nome = i.Nome,
            //                   Tipo = i.Tipo,
            //                   Reduzida = i.Reduzida,
            //                   ReduzidaAntiga = i.ReduzidaAntiga,
            //                   Pessoa = i.Pessoa,
            //                   Selecionado = false,
            //                   Habilitado = true,
            //                   Situacao = ""
            //               }).ToList<ContaContabil>();

            //plcontas.TrimStrings = true;

            List<LancamentoFluxoCaixa> Lancamentos = (from i in LancamentosFluxoCaixaList
                                             select new LancamentoFluxoCaixa()
                                             {
                                                 Titulo = i.Titulo,
                                                 Documento = i.Documento,
                                                 Pedido = i.Pedido,
                                                 Origem = i.Origem,
                                                 Emissao = i.Emissao,
                                                 Vencimento = i.Vencimento,
                                                 Pagamento = i.Pagamento,
                                                 Faturamento = i.Faturamento,
                                                 CNPJ = i.CNPJ,
                                                 Titular = i.Titular,
                                                 Valor = i.Valor,
                                                 ValorBaixa = i.ValorBaixa,
                                                 Tipo = i.Tipo,
                                                 Banco = i.Banco,
                                                 Parcela = i.Parcela,
                                                 Parcelas = i.Parcelas,
                                                 Observacao = i.Observacao,
                                                 Selecionado = false, //i.Lancamento == 0 ? true : false,
                                                 Lancamento = i.Lancamento,
                                                 Sequencia = i.Sequencia,
                                                 Debito = i.CCDebito,
                                                 Credito = i.CCCredito,
                                                 Situacao = i.Conciliacao == null ? "" : "Atualizado"
                                             }).ToList<LancamentoFluxoCaixa>();

            ICollectionView LancamentosView =
            CollectionViewSource.GetDefaultView(Lancamentos);

            // Set the grouping by city proprty
            LancamentosView.GroupDescriptions.Add(new PropertyGroupDescription("Pedido"));

            LancamentosFluxoCaixaDataGrid.ItemsSource = Lancamentos;

            #endregion
        }

        private void CCDebitoReduzidaTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (CCDebitoReduzidaTextBox.Text.Trim().Length > 0)
            {
                int reduzida = 0;

                if (int.TryParse(CCDebitoReduzidaTextBox.Text.Trim(), out reduzida))
                {
                    int r;

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    PlContas plcontas = new PlContas();

                    plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

                    if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                    plcontas.Keys.idxindex_2.sgmReduzida = reduzida;

                    // Verifica se a Conta existe
                    if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("A Conta {0} não foi encontrada !", reduzida), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        CCDebitoReduzidaTextBox.Text = "";
                    }
                    else 
                    {
                        CCDebitoTextBox.Text = plcontas.fldConta.Trim();
                        CCDebitoNomeTextBox.Text = plcontas.fldDescricao.Trim();
                    }

                    plcontas.btrClose();
                    plcontas = null;

                }
                //else if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper() == "CLIENTES")
                //{

                //}
                //else if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper() == "FORNECEDORES")
                //{
                //}
                //else if (CCDebitoReduzidaTextBox.Text.Trim().ToUpper() == "BANCOS")
                //{
                //}
            }
        }

        private void CCCreditoReduzidaTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (CCCreditoReduzidaTextBox.Text.Trim().Length > 0)
            {
                int reduzida = 0;

                if (int.TryParse(CCCreditoReduzidaTextBox.Text.Trim(), out reduzida))
                {
                    int r;

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro do Plano de Contas '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    PlContas plcontas = new PlContas();

                    plcontas.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr");

                    if ((r = plcontas.btrOpen(PlContas.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    plcontas.Keys.idxindex_2.sgmIdPlano = Properties.Settings.Default.PlanoContasAtual;
                    plcontas.Keys.idxindex_2.sgmReduzida = reduzida;

                    // Verifica se a Conta existe
                    if ((r = plcontas.btrGetEqual(PlContas.KeyName.index_2, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("A Conta {0} não foi encontrada !", reduzida), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        CCCreditoReduzidaTextBox.Text = "";
                    }
                    else 
                    {
                        CCCreditoTextBox.Text = plcontas.fldConta.Trim();
                        CCCreditoNomeTextBox.Text = plcontas.fldDescricao.Trim();
                    }

                    plcontas.btrClose();
                    plcontas = null;

                }
            }
        }

        private void CheckSelectedLancamentos(object sender, RoutedEventArgs e)
        {
            foreach (LancamentoFluxoCaixa i in LancamentosFluxoCaixaDataGrid.SelectedItems)
            {
                i.Selecionado = true;
            }
        }

        private void UncheckSelectedLancamentos(object sender, RoutedEventArgs e)
        {
            foreach (LancamentoFluxoCaixa i in LancamentosFluxoCaixaDataGrid.SelectedItems)
            {
                i.Selecionado = false;
            }
        }

        private void HistoricoCodigoTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (HistoricoCodigoTextBox.Text.Trim().Length > 0)
            {
                int codigo = 0;

                if (int.TryParse(HistoricoCodigoTextBox.Text.Trim(), out codigo))
                {
                    int r;

                    if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr")))
                    {
                        MessageBox.Show(string.Format("O arquivo de cadastro Historico Padrão '{0}' não foi encontrado !", System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    HPADRAO hpadrao = new HPADRAO();

                    hpadrao.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"HPADRAO.btr");

                    if ((r = hpadrao.btrOpen(HPADRAO.OpenModes.Normal, pvClientId)) != 0)
                    {
                        MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}. Verifique se o arquivo existe e se não esta protegido contra gravação.", System.IO.Path.Combine(Properties.Settings.Default.GeralPath.Trim(), @"PlContas.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }

                    hpadrao.Keys.idxindex_0.sgmCodigo = codigo;

                    // Verifica se a Conta existe
                    if ((r = hpadrao.btrGetEqual(HPADRAO.KeyName.index_0, pvClientId)) != 0)
                    {
                        MessageBox.Show(String.Format("O Historico Padrão {0} não foi encontrada !", codigo), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                        HistoricoCodigoTextBox.Text = "";
                    }
                    else
                    {
                        HistoricoDescricaoTextBox.Text = hpadrao.fldHistorico.Trim();
                        HistoricoComplementoTextBox.Text = hpadrao.fldHistorico.Trim() + " ";
                    }

                    hpadrao.btrClose();
                    hpadrao = null;

                }
            }
        }

        private void ComplementoDocumentoButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"DOCUMENTO\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoTitularButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"TITULAR\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoPagamentoButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"PAGAMENTO\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoValorButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"VALOR\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoPedidoButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"PEDIDO\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoBancoButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"BANCO\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoCNPJButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"CNPJ\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void ComplementoVencimentoButton_Click(object sender, RoutedEventArgs e)
        {
            HistoricoComplementoTextBox.Text = HistoricoComplementoTextBox.Text.Trim() + " \"VENCIMENTO\"";
            HistoricoComplementoTextBox.CaretIndex = HistoricoComplementoTextBox.Text.Length;
            HistoricoComplementoTextBox.Focus();
        }

        private void CCDebitoClienteButton_Click(object sender, RoutedEventArgs e)
        {
            CCDebitoReduzidaTextBox.Text = "CLIENTE";
            CCDebitoTextBox.Text = "";
            CCDebitoNomeTextBox.Text = "CLIENTE";
            CCDebitoReduzidaTextBox.Focus();
        }

        private void CCDebitoFornecedorButton_Click(object sender, RoutedEventArgs e)
        {
            CCDebitoReduzidaTextBox.Text = "FORNECEDOR";
            CCDebitoTextBox.Text = "";
            CCDebitoNomeTextBox.Text = "FORNECEDOR";
            CCDebitoReduzidaTextBox.Focus();
        }

        private void CCCreditoClienteButton_Click(object sender, RoutedEventArgs e)
        {
            CCCreditoReduzidaTextBox.Text = "CLIENTE";
            CCCreditoTextBox.Text = "";
            CCCreditoNomeTextBox.Text = "CLIENTE";
            CCCreditoReduzidaTextBox.Focus();
        }

        private void CCCreditoFornecedorButton_Click(object sender, RoutedEventArgs e)
        {
            CCCreditoReduzidaTextBox.Text = "FORNECEDOR";
            CCCreditoTextBox.Text = "";
            CCCreditoNomeTextBox.Text = "FORNECEDOR";
            CCCreditoReduzidaTextBox.Focus();
        }

        private void TextBox_SelectAll(object sender, RoutedEventArgs e)
        {
            var textBox = e.OriginalSource as TextBox;
            if (textBox != null)
            {
                Keyboard.Focus(textBox);
                textBox.SelectAll();
            }  
        }

        private void TextBox_SelectAll(object sender, MouseEventArgs e)
        {
            var textBox = e.OriginalSource as TextBox;
            if (textBox != null)
            {
                Keyboard.Focus(textBox);
                textBox.SelectAll();
            } 
        }

        private void TextBox_SelectAll(object sender, KeyboardFocusChangedEventArgs e)
        {
            var textBox = e.OriginalSource as TextBox;
            if (textBox != null)
            {
                Keyboard.Focus(textBox);
                textBox.SelectAll();
            } 
        }

        private void ClearFilterButton_Click(object sender, RoutedEventArgs e)
        {
            FiltroTextBox.Text = "";
        }
    }

}
