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
using System.Windows.Shapes;
using System.Configuration;
using System.IO;
using CONTMATIC.Geral;
using System.Security.Permissions;
using System.Security;

namespace CONTMATIC
{
    /// <summary>
    /// Interaction logic for Config.xaml
    /// </summary>
    public partial class Config : Window
    {
        Byte[] pvClientId;

        public Config(Byte[] pvClientId)
        {
            InitializeComponent();

            this.pvClientId = pvClientId;

            LoadConfiguration(this, new RoutedEventArgs());
        }

        private void LoadConfiguration(object sender, RoutedEventArgs e)
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

            PlanoContasAtualCombobox.Text = Properties.Settings.Default.PlanoContasAtual.ToString();
            PlanoContasAnteriorCombobox.Text = Properties.Settings.Default.PlanoContasAnterior.ToString();
            GeralPathTextbox.Text = Properties.Settings.Default.GeralPath;
            EmpresaPathTextbox.Text = Properties.Settings.Default.EmpresaPath;
            WebserviceURLTextbox.Text = Properties.Settings.Default.WebServiceURL;
            UsuarioTextbox.Text = Properties.Settings.Default.Usuario;
            SenhaTextbox.Password = Properties.Settings.Default.Senha;

            if (!File.Exists(System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr")))
                return;

            NPCCTB npcctb = new NPCCTB();

            npcctb.DataPath = System.IO.Path.Combine(Properties.Settings.Default.GeralPath, @"NPCCTB.btr");

            if ((r = npcctb.btrOpen(NPCCTB.OpenModes.Read_Only, pvClientId)) == 0)
            {
                if ((r = npcctb.btrGetFirst(NPCCTB.KeyName.index_0, pvClientId)) == 0)
                {
                    do
                    {
                        ComboBoxItem c = new ComboBoxItem();
                        c.Content = npcctb.fldIdPlano.ToString();
                        c.Tag = npcctb.fldIdPlano.ToString();

                        PlanoContasAtualCombobox.Items.Add(c);

                        if (Properties.Settings.Default.PlanoContasAtual == npcctb.fldIdPlano)
                            PlanoContasAtualCombobox.SelectedIndex = PlanoContasAtualCombobox.Items.Count - 1;

                        ComboBoxItem c2 = new ComboBoxItem();
                        c2.Content = npcctb.fldIdPlano.ToString();
                        c2.Tag = npcctb.fldIdPlano.ToString();

                        PlanoContasAnteriorCombobox.Items.Add(c2);

                        if (Properties.Settings.Default.PlanoContasAnterior == npcctb.fldIdPlano)
                            PlanoContasAnteriorCombobox.SelectedIndex = PlanoContasAnteriorCombobox.Items.Count - 1;

                    } while (npcctb.btrGetNext(NPCCTB.KeyName.index_0, pvClientId) == 0);
                }
            }

            npcctb.btrClose(pvClientId);
            npcctb = null;
        }

        private void SaveConfiguration(object sender, RoutedEventArgs e)
        {
            FileIOPermission f1 = new FileIOPermission(FileIOPermissionAccess.Read, GeralPathTextbox.Text.Trim());
            f1.AddPathList(FileIOPermissionAccess.Write | FileIOPermissionAccess.Read, GeralPathTextbox.Text.Trim());
            try
            {
                f1.Demand();
            }
            catch (SecurityException s)
            {
                Console.WriteLine(s.Message);
            }

            FileIOPermission f2 = new FileIOPermission(FileIOPermissionAccess.Read, EmpresaPathTextbox.Text.Trim());
            f2.AddPathList(FileIOPermissionAccess.Write | FileIOPermissionAccess.Read, EmpresaPathTextbox.Text.Trim());
            try
            {
                f2.Demand();
            }
            catch (SecurityException s)
            {
                Console.WriteLine(s.Message);
            }

            DirectoryInfo d = new DirectoryInfo(@GeralPathTextbox.Text.Trim());
            if (!d.Exists)
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", GeralPathTextbox.Text.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!Directory.Exists(EmpresaPathTextbox.Text.Trim()))
            {
                MessageBox.Show(string.Format("O diretorio '{0}' não foi encontrado !", EmpresaPathTextbox.Text.Trim()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            short r;

            int pAtual, pAnterior = 0;

            if (!int.TryParse(PlanoContasAtualCombobox.Text, out pAtual))
            {
                MessageBox.Show(string.Format("O código do Plano de Contas Atual é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!int.TryParse(PlanoContasAnteriorCombobox.Text, out pAnterior))
            {
                MessageBox.Show(string.Format("O código do Plano de Contas Anterior é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (!File.Exists(System.IO.Path.Combine(GeralPathTextbox.Text.Trim(), @"NPCCTB.btr")))
            {
                MessageBox.Show(string.Format("O arquivo com o cadastro de Plano de Contas em '{0}' não foi encontrado !", System.IO.Path.Combine(GeralPathTextbox.Text.Trim(), @"NPCCTB.btr")), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            NPCCTB npcctb = new NPCCTB();

            npcctb.DataPath = System.IO.Path.Combine(GeralPathTextbox.Text.Trim(), @"NPCCTB.btr");

            if ((r = npcctb.btrOpen(NPCCTB.OpenModes.Read_Only, pvClientId)) == 0)
            {
                npcctb.Keys.idxindex_0.sgmIdPlano = pAtual;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0, pvClientId)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas Atual {0} não foi encontrado ou ocorreu um erro !\nCodigo do erro: {1}.", pAtual.ToString(), r), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                npcctb.Keys.idxindex_0.sgmIdPlano = pAnterior;

                if ((r = npcctb.btrGetEqual(NPCCTB.KeyName.index_0, pvClientId)) != 0)
                {
                    MessageBox.Show(string.Format("O Plano de Contas Anterior {0} não foi encontrado !", pAnterior.ToString()), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                npcctb.btrClose(pvClientId);
            }
            else
            {
                MessageBox.Show(string.Format("Erro ao abrir o arquivo {0}.\nO código do erro: {1}.", System.IO.Path.Combine(GeralPathTextbox.Text.Trim(), @"NPCCTB.btr"), r), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (WebserviceURLTextbox.Text.Trim() == string.Empty)
            {
                MessageBox.Show(string.Format("O endereço de Webservice é inválido !"), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            try
            {
                Service.PlanoContasClient plclient = new Service.PlanoContasClient();

                plclient.Endpoint.Address = new System.ServiceModel.EndpointAddress(WebserviceURLTextbox.Text.Trim());
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Falha na conexão com o servidor da Altamira em {0}.\n\nFavor entrar em contato com o suporte técnico no telefone (11) 2095-2855 ramal 2821/2890 ou pelo e-mail suporte.ti@altamira.com.br.\n\nMensagem de erro: {1}", Properties.Settings.Default.WebServiceURL, ex.Message), "Altamira - Integracao Contabil", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            Properties.Settings.Default.PlanoContasAtual = pAtual;
            Properties.Settings.Default.PlanoContasAnterior = pAnterior;
            Properties.Settings.Default.GeralPath = GeralPathTextbox.Text.Trim();
            Properties.Settings.Default.EmpresaPath = EmpresaPathTextbox.Text.Trim();
            Properties.Settings.Default.WebServiceURL = WebserviceURLTextbox.Text.Trim(); //@"http://consult.altamira.com.br:5555/PlanoContas.svc"
            Properties.Settings.Default.Usuario = UsuarioTextbox.Text;
            Properties.Settings.Default.Senha = SenhaTextbox.Password;

            Properties.Settings.Default.Save();

            this.Close();
        }

        internal static bool SetSetting(string Key, string Value)
        {
            bool result = false;
            try
            {
                System.Configuration.Configuration config =
                  ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);

                config.AppSettings.Settings.Remove(Key);
                var kvElem = new KeyValueConfigurationElement(Key, Value);
                config.AppSettings.Settings.Add(kvElem);

                // Save the configuration file.
                config.Save(ConfigurationSaveMode.Modified);

                // Force a reload of a changed section.
                ConfigurationManager.RefreshSection("appSettings");

                result = true;
            }
            finally
            { }
            return result;
        } // function
    }
    
}
