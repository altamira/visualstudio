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
using System.Windows.Forms;
using System.IO;
using ScriptDiff;
using System.Diagnostics;

namespace WpfConsole
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void SelectFileFromButton_Click(object sender, RoutedEventArgs e)
        {
            // Configure open file dialog box
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.FileName = "script.sql"; // Default file name
            dlg.DefaultExt = ".sql"; // Default file extension
            dlg.Filter = "SQL Database Script (.sql)|*.sql"; // Filter files by extension
            dlg.CheckFileExists = true;

            // Show open file dialog box
            Nullable<bool> result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result == true)
            {
                // Open document
                FromFileNameTextBlock.Text = dlg.FileName;
            }


        }

        private void SelectFileToButton_Click(object sender, RoutedEventArgs e)
        {
            // Configure open file dialog box
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.FileName = "script.sql"; // Default file name
            dlg.DefaultExt = ".sql"; // Default file extension
            dlg.Filter = "SQL Database Script (.sql)|*.sql"; // Filter files by extension
            dlg.CheckFileExists = true;

            // Show open file dialog box
            Nullable<bool> result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result == true)
            {
                // Open document
                ToFileNameTextBlock.Text = dlg.FileName;
            }
        }

        private void ParseButton_Click(object sender, RoutedEventArgs e)
        {
            string[] args = { FromFileNameTextBlock.Text, FromOutputDirTextBlock.Text };

            try
            {

                if (Directory.Exists(FromOutputDirTextBlock.Text))
                    Directory.Delete(FromOutputDirTextBlock.Text, true);

                if (Do(args) > 0)
                    Results.Text += "\nParse of the first script ok...\n";

                string[] argsToCompateTo = { ToFileNameTextBlock.Text, ToOutputDirTextBlock.Text };

                if (Directory.Exists(ToOutputDirTextBlock.Text))
                    Directory.Delete(ToOutputDirTextBlock.Text, true);

                if (Do(argsToCompateTo) > 0)
                    Results.Text += "\nParse of the second script ok...\n";

                SaveSettings();
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(ex.Message);
            }
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            System.Windows.Application.Current.Shutdown();
        }

        private void FromOutputDirButton_Click(object sender, RoutedEventArgs e)
        {
            // Configure open file dialog box
            System.Windows.Forms.FolderBrowserDialog dlg = new System.Windows.Forms.FolderBrowserDialog(); 
            dlg.RootFolder = Environment.SpecialFolder.Personal;
            dlg.SelectedPath = FromOutputDirTextBlock.Text;

            // Show open file dialog box
            DialogResult result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result == System.Windows.Forms.DialogResult.OK)
            {
                // Open document
                FromOutputDirTextBlock.Text = dlg.SelectedPath;

            }
        }

        private void ToOutputDirButton_Click(object sender, RoutedEventArgs e)
        {
            // Configure open file dialog box
            System.Windows.Forms.FolderBrowserDialog dlg = new System.Windows.Forms.FolderBrowserDialog();
            dlg.RootFolder = Environment.SpecialFolder.Personal;
            dlg.SelectedPath = ToOutputDirTextBlock.Text;

            // Show open file dialog box
            DialogResult result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result == System.Windows.Forms.DialogResult.OK)
            {
                // Open document
                ToOutputDirTextBlock.Text = dlg.SelectedPath;
            }
        }

        static String SourceScriptFileName;
        static String OutputDir;
        static StreamReader script;
        static bool Silent = false;

        const string WELCOME = "This program helps on split a large database script, generated by SQL Server, into smallest files under output directory to helps individual comparation with WinMerge diff utility.\nUsage <Script.sql> <Output path> [/S]\n    /S - No show logs";
        const String BLOCK_ENTRY_STRING = "/****** Object:";

        public int Do(string[] args)
        {
            if (args.Length < 2)
            {
                System.Windows.MessageBox.Show("Parametros invalidos !");
                return 0;
            }

            SourceScriptFileName = args[0];
            OutputDir = args[1];

            String CurrentDir = Directory.GetCurrentDirectory();

            int counter = 0;
            String line;

            if (SourceScriptFileName.Length == 0 ||
                OutputDir.Length == 0 ||
                !File.Exists(SourceScriptFileName))
            {
                System.Windows.MessageBox.Show(WELCOME);
                return 0;
            }

            if (SourceScriptFileName.Length == 0 || OutputDir.Length == 0)
            {
                System.Windows.MessageBox.Show("Usage <Database Script.sql> <Output path>");
                return 0;
            }

            this.Cursor = System.Windows.Input.Cursors.Wait;

            script = new System.IO.StreamReader(SourceScriptFileName);

            line = script.ReadLine();

            while (line != null)
            {
                if (line.StartsWith(BLOCK_ENTRY_STRING))
                    line = GetScriptBlock(GetFile(line));
                else
                {
                    Results.Text += "\nIgnored line: " + line;
                    line = script.ReadLine();
                }

                counter++;
            }

            script.Close();

            this.Cursor = System.Windows.Input.Cursors.Arrow;

            Results.Text += "\n\nDone !\n";
            Results.Text += "\n" + counter.ToString() + " block(s) processed from " + SourceScriptFileName + "\n";
            return 1;
        }

        public String GetScriptBlock(StreamWriter FileBlock)
        {
            String line = null;

            while ((line = script.ReadLine()) != null)
            {
                if (line.StartsWith(BLOCK_ENTRY_STRING))
                    break;

                FileBlock.WriteLine(line);
            }

            FileBlock.Close();

            return line;
        }

        public StreamWriter GetFile(String Header)
        {
            String FileName = Header.Substring(BLOCK_ENTRY_STRING.Length, Header.IndexOf("Script Date") - BLOCK_ENTRY_STRING.Length).Trim().Replace(" ", ".") + ".sql";
            String DirectoryName = /*Directory.GetCurrentDirectory() + "\\" + */OutputDir;

            if (!Silent)
                Results.Text += "\nProcessing script file: " + FileName;

            Directory.CreateDirectory(DirectoryName);
            StreamWriter FileBlock = new StreamWriter(DirectoryName + "\\" + FileName.Replace("\\", "_"));
            return FileBlock;
        }

        private void ParseDiffButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                ParseButton_Click(this, e);

                Process process = new Process();
                process.StartInfo.FileName = "C:\\Program Files (x86)\\WinMerge\\WinMergeU.exe";
                process.StartInfo.WorkingDirectory = "C:\\Program Files (x86)\\WinMerge";
                process.StartInfo.Arguments = String.Format("/r /e /f *.sql /u {0} {1}", FromOutputDirTextBlock.Text, ToOutputDirTextBlock.Text);
                process.Start();

                SaveSettings();
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(ex.Message);
            }
        }

        private void SaveSettings()
        {
            Properties.Settings.Default.FromFileName = FromFileNameTextBlock.Text;
            Properties.Settings.Default.FromOutputDir = FromOutputDirTextBlock.Text;
            Properties.Settings.Default.ToFileName = ToFileNameTextBlock.Text;
            Properties.Settings.Default.ToOutputDir = ToOutputDirTextBlock.Text;
            Properties.Settings.Default.Save();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FromFileNameTextBlock.Text = Properties.Settings.Default.FromFileName;
            FromOutputDirTextBlock.Text = Properties.Settings.Default.FromOutputDir;
            ToFileNameTextBlock.Text = Properties.Settings.Default.ToFileName;
            ToOutputDirTextBlock.Text = Properties.Settings.Default.ToOutputDir;
        }
    }
}
