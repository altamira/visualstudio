using System;
using System.ComponentModel.Composition;
using System.Windows;
using System.Windows.Controls.Ribbon;
using ViewModel;

namespace WPF.Views
{
    /// <summary>
    /// Interaction logic for CustomerView.xaml
    /// </summary>
    [Export(typeof(InvoiceView))]
    public partial class InvoiceView : RibbonWindow
    {
        public InvoiceView(InvoiceViewModel viewModel)
        {
            //InitializeComponent();

            this.Loaded += (s, e) =>
                {
                    this.DataContext = viewModel;
                };
        }

        void InvoiceView_Loaded(object sender, RoutedEventArgs e)
        {
            throw new NotImplementedException();
        }

        //private void PrintDANFEButton_Click(object sender, RoutedEventArgs e)
        //{
        //    //List<ReportParameter> parameters = new List<ReportParameter>();

        //    //parameters.Add(new ReportParameter("rptImagePath", string.Format("file://{0}\\{1}", Application.StartupPath.ToString(), "logotipos\\logo_altamira.png")));

        //    //string myXMLFile = string.Format("{0}\\{1}", Application.StartupPath.ToString(), "GP_NFe_01_000008452_exp.xml");

        //    //DataSet ds = new DataSet();

        //    //FileStream fso = new FileStream(myXMLFile, FileMode.Open);

        //    //try
        //    //{
        //    //    ds.ReadXml(fso);

        //    //    List<ReportDataSource> rptDataSource = new List<ReportDataSource>();

        //    //    string tabelas = "<html><head><title>Documentação de campos da NFe</title><style>body {font-family: verdana; font-size: 10px;} tr:first-child > td { font-weight: bold; }</style></head><body>";

        //    //    foreach (DataTable tableSource in ds.Tables)
        //    //    {
        //    //        tabelas += "<table style=\"border: 1px solid; width: 640px; \" border=\"1\" cellpadding=\"2\">";
        //    //        tabelas += string.Format("<tr><td>Tabela: {0}</td><td>Colunas: {1} - Linhas: {2}</td></tr>", tableSource.TableName, tableSource.Columns.Count, tableSource.Rows.Count);

        //    //        foreach (DataColumn dc in tableSource.Columns)
        //    //        {
        //    //            tabelas += string.Format("<tr><td>&nbsp;</td><td>Campo: {0} - Tipo: {1}</td</tr>", dc.ColumnName, dc.DataType.ToString());
        //    //        }

        //    //        tabelas += "</table><br /><br />";

        //    //        tabelas += "<table style=\"border: 1px solid; width: 100%; \" border=\"1\" cellpadding=\"2\">";

        //    //        tabelas += "<tr>";
        //    //        foreach (DataColumn dc in tableSource.Columns)
        //    //        {
        //    //            tabelas += string.Format("<td>{0}</td>", dc.ColumnName);
        //    //        }
        //    //        tabelas += "</tr>";


        //    //        foreach (DataRow dr in tableSource.Rows)
        //    //        {
        //    //            tabelas += "<tr>";
        //    //            foreach (DataColumn dc in tableSource.Columns)
        //    //            {
        //    //                tabelas += string.Format("<td>{0}</td>", dr[dc.ColumnName].ToString());
        //    //            }
        //    //            tabelas += "</tr>";
        //    //        }

        //    //        tabelas += "</table><hr>";


        //    //        this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource(tableSource.TableName, tableSource));
        //    //    }

        //    //    tabelas += "</body></html>";

        //    //    this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource("mergedProdDet", UniteDataTable(ds.Tables["prod"], ds.Tables["det"], "mergedProdDet")));

        //    //    string pathToFile = string.Format("{0}\\Tabelas.htm", Application.StartupPath.ToString());

        //    //    if (File.Exists(pathToFile))
        //    //    {
        //    //        File.Delete(pathToFile);
        //    //    }

        //    //    File.WriteAllText(pathToFile, tabelas, Encoding.ASCII);

        //    //    this.reportViewer1.LocalReport.EnableExternalImages = true;

        //    //    this.reportViewer1.LocalReport.ReportPath = string.Format("{0}\\{1}", Application.StartupPath.ToString(), "rptDANFE.rdlc");
        //    //    this.reportViewer1.LocalReport.SetParameters(parameters);

        //    //    this.reportViewer1.RefreshReport();

        //    //}
        //    //catch (Exception ex)
        //    //{
        //    //}

        //}
    }
}
