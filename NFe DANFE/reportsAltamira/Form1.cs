using Microsoft.Reporting.WinForms;
using reportsAltamira.Properties;
//------------------------------------------------------------------
// <copyright company="Microsoft">
//     Copyright (c) Microsoft.  All rights reserved.
// </copyright>
//------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Schema;

namespace reportsAltamira
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Form1_Load(this, new EventArgs());
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            List<String> notasFiscais = new List<string>();

            foreach (string fileName in Directory.EnumerateFiles(Application.StartupPath.ToString() + "\\NFe\\", "*.xml"))
            {
                notasFiscais.Add(Path.GetFileName(fileName));
            }

            notasFiscais.Insert(0, "Selecione");

            comboBox1.DataSource = notasFiscais;
            comboBox1.FlatStyle = FlatStyle.Popup;
            this.reportViewer1.SetDisplayMode(DisplayMode.PrintLayout);
        }

                private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBox1.SelectedText != "Selecione")
            {
                List<ReportParameter> parameters = new List<ReportParameter>();

                parameters.Add(new ReportParameter("rptImagePath", string.Format("file://{0}\\{1}", Application.StartupPath.ToString(), "logotipos\\logo_altamira.png")));

                string myXMLFile = string.Format("{0}\\NFe\\{1}", Application.StartupPath.ToString(), comboBox1.SelectedItem);
                string myXMLSchema = string.Format("{0}\\schemas\\nfe_v2.00.xsd", Application.StartupPath.ToString());
                this.reportViewer1.LocalReport.DataSources.Clear();
                
                DataSet ds = new DataSet();
                if (File.Exists(myXMLFile))
                {
                    FileStream fso = new FileStream(myXMLFile, FileMode.Open);

                    ds.ReadXml(fso);

                    List<String> schemasNFe = new List<string>();

                    using (FileStream fsoSchema = new FileStream(Application.StartupPath.ToString() + "\\schemas\\nfe_v2.00.xsd", FileMode.Open))
                    {
                        XmlSchema mainSchema = XmlSchema.Read(XmlReader.Create(fsoSchema), null);
                        //mainSchema.TargetNamespace = "http://www.portalfiscal.inf.br/nfe";

                        foreach (string fileName in Directory.EnumerateFiles(Application.StartupPath.ToString() + "\\schemas\\", "*.xsd"))
                        {
                            if (Path.GetFileName(fileName) != "nfe_v2.00.xsd")
                            {
                                using (FileStream fsoSchemaInclude = new FileStream(fileName, FileMode.Open))
                                {
                                    var includeSchema = XmlSchema.Read(XmlReader.Create(fsoSchemaInclude), null);
                                    //includeSchema.TargetNamespace = "http://www.w3.org/2000/09/xmldsig#";
                                    
                                    var includeXMLSchema = new XmlSchemaInclude();
                                    includeXMLSchema.Schema = includeSchema;
                                    mainSchema.Includes.Add(includeXMLSchema);
                                }
                            }
                        }
                        try
                        {
                            var schemaSet = new XmlSchemaSet();
                            schemaSet.ValidationEventHandler += schemaSet_ValidationEventHandler;
                            schemaSet.Add(mainSchema);
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message);
                        }
                    }

                    List<ReportDataSource> rptDataSource = new List<ReportDataSource>();

                    string tabelas = "<html><head><title>Documentação de campos da NFe</title><style>body {font-family: verdana; font-size: 10px;} tr:first-child > td { font-weight: bold; }</style></head><body>";

                    foreach (DataTable tableSource in ds.Tables)
                    {
                        tabelas += "<table style=\"border: 1px solid; width: 640px; \" border=\"1\" cellpadding=\"2\">";
                        tabelas += string.Format("<tr><td>Tabela: {0}</td><td>Colunas: {1} - Linhas: {2}</td></tr>", tableSource.TableName, tableSource.Columns.Count, tableSource.Rows.Count);

                        foreach (DataColumn dc in tableSource.Columns)
                        {
                            tabelas += string.Format("<tr><td>&nbsp;</td><td>Campo: {0} - Tipo: {1}</td</tr>", dc.ColumnName, dc.DataType.ToString());
                        }

                        tabelas += "</table><br /><br />";

                        tabelas += "<table style=\"border: 1px solid; width: 100%; \" border=\"1\" cellpadding=\"2\">";

                        tabelas += "<tr>";
                        foreach (DataColumn dc in tableSource.Columns)
                        {
                            tabelas += string.Format("<td>{0}</td>", dc.ColumnName);
                        }
                        tabelas += "</tr>";


                        foreach (DataRow dr in tableSource.Rows)
                        {
                            tabelas += "<tr>";
                            foreach (DataColumn dc in tableSource.Columns)
                            {
                                tabelas += string.Format("<td>{0}</td>", dr[dc.ColumnName].ToString());
                            }
                            tabelas += "</tr>";
                        }

                        tabelas += "</table><hr>";

                        this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource(tableSource.TableName, tableSource));
                    }

                    List<string> principalDataSets = new List<string>(new string[] { "prod", "NFe", "ide", "det", "dest", "emit", "enderEmit", "infAdic", "dup", "infNFe", "infProt", "enderDest", "ICMSTot", "transporta", "vol", "transp" });


                    tabelas += "</body></html>";

                    foreach (string strDs in principalDataSets)
                    {
                        if (!ds.Tables.Contains(strDs))
                        {
                            DataTable dt = new DataTable();

                            if (strDs == "vol")
                                dt = ToDataTable<vol>(new List<vol>());

                            dt.TableName = strDs;

                            this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource(strDs, dt));
                        }
                    }

                    DataTable dtProdDet = ToDataTable<prodDetails>(new List<prodDetails>());

                    string tICMS = (ds.Tables.Contains("ICMS00")) ? "ICMS00" : 
                        (ds.Tables.Contains("ICMS20")) ? "ICMS20" :
                        "I";

                    if (tICMS == "I")
                    {
                        DataTable dtICMS = ToDataTable<ICMS>(new List<ICMS>());
                        
                        dtICMS.TableName = tICMS = "ICMS00";
                        
                        ds.Tables.Add(dtICMS);
                    }

                    try
                    {
                        var prodDet = (from p in ds.Tables["prod"].AsEnumerable()
                                       join d in ds.Tables["det"].AsEnumerable()
                                       on p.Field<Int32>("det_id").ToString() equals d.Field<Int32>("det_id").ToString()
                                       join imp in ds.Tables["imposto"].AsEnumerable() on 
                                       d.Field<Int32>("det_id").ToString() equals imp.Field<Int32>("det_id").ToString() 
                                       join icms in ds.Tables["ICMS"].AsEnumerable() on
                                       imp.Field<Int32>("imposto_id").ToString() equals icms.Field<Int32>("imposto_id").ToString() 
                                       into impICMS from ICMSImp in impICMS.DefaultIfEmpty()
                                       join icms00 in ds.Tables[tICMS].AsEnumerable() on
                                       ICMSImp.Field<Int32>("ICMS_Id").ToString() equals icms00.Field<Int32>("ICMS_Id").ToString()
                                       into valICMS from icmsVal in valICMS.Where(i => i.Field<Int32>("ICMS_Id").ToString() == ICMSImp.Field<Int32>("ICMS_Id").ToString()).DefaultIfEmpty(ICMSImp)
                                       select new prodDetails
                                       {
                                           det_id = d.Field<Int32>("det_id"),
                                           infAdProd = (d.Table.Columns.Contains("infAdProd")) ? (!string.IsNullOrEmpty(d.Field<String>("infAdProd"))) ? d.Field<String>("infAdProd").Replace(".", ",") : string.Empty : string.Empty,
                                           nItem = (d.Table.Columns.Contains("nItem")) ? (!string.IsNullOrEmpty(d.Field<String>("nItem"))) ? d.Field<String>("nItem").Replace(".", ",") : string.Empty : string.Empty,
                                           cProd = (p.Table.Columns.Contains("cProd")) ? (!string.IsNullOrEmpty(p.Field<String>("cProd"))) ? p.Field<String>("cProd").Replace(".", ",") : string.Empty : string.Empty,
                                           cEAN = (p.Table.Columns.Contains("cEAN")) ? (!string.IsNullOrEmpty(p.Field<String>("cEAN"))) ? p.Field<String>("cEAN").Replace(".", ",") : string.Empty : string.Empty,
                                           xProd = (p.Table.Columns.Contains("xProd")) ? (!string.IsNullOrEmpty(p.Field<String>("xProd"))) ? p.Field<String>("xProd").Replace(".", ",") : string.Empty : string.Empty,
                                           NCM = (p.Table.Columns.Contains("NCM")) ? (!string.IsNullOrEmpty(p.Field<String>("NCM"))) ? p.Field<String>("NCM").Replace(".", ",") : string.Empty : string.Empty,
                                           CFOP = (p.Table.Columns.Contains("CFOP")) ? (!string.IsNullOrEmpty(p.Field<String>("CFOP"))) ? p.Field<String>("CFOP").Replace(".", ",") : string.Empty : string.Empty,
                                           uCom = (p.Table.Columns.Contains("uCom")) ? (!string.IsNullOrEmpty(p.Field<String>("uCom"))) ? p.Field<String>("uCom").Replace(".", ",") : string.Empty : string.Empty,
                                           qCom = (p.Table.Columns.Contains("qCom")) ? (!string.IsNullOrEmpty(p.Field<String>("qCom"))) ? p.Field<String>("qCom").Replace(".", ",") : string.Empty : string.Empty,
                                           vUnCom = (p.Table.Columns.Contains("vUnCom")) ? (!string.IsNullOrEmpty(p.Field<String>("vUnCom"))) ? p.Field<String>("vUnCom").Replace(".", ",") : string.Empty : string.Empty,
                                           vProd = (p.Table.Columns.Contains("vProd")) ? (!string.IsNullOrEmpty(p.Field<String>("vProd"))) ? p.Field<String>("vProd").Replace(".", ",") : string.Empty : string.Empty,
                                           cEANTrib = (p.Table.Columns.Contains("cEANTrib")) ? (!string.IsNullOrEmpty(p.Field<String>("cEANTrib"))) ? p.Field<String>("cEANTrib").Replace(".", ",") : string.Empty : string.Empty,
                                           uTrib = (p.Table.Columns.Contains("uTrib")) ? (!string.IsNullOrEmpty(p.Field<String>("uTrib"))) ? p.Field<String>("uTrib").Replace(".", ",") : string.Empty : string.Empty,
                                           qTrib = (p.Table.Columns.Contains("qTrib")) ? (!string.IsNullOrEmpty(p.Field<String>("qTrib"))) ? p.Field<String>("qTrib").Replace(".", ",") : string.Empty : string.Empty,
                                           vUnTrib = (p.Table.Columns.Contains("vUnTrib")) ? (!string.IsNullOrEmpty(p.Field<String>("vUnTrib"))) ? p.Field<String>("vUnTrib").Replace(".", ",") : string.Empty : string.Empty,
                                           indTot = (p.Table.Columns.Contains("indTot")) ? (!string.IsNullOrEmpty(p.Field<String>("indTot"))) ? p.Field<String>("indTot").Replace(".", ",") : string.Empty : string.Empty,
                                           xPed = (p.Table.Columns.Contains("xPed")) ? (!string.IsNullOrEmpty(p.Field<String>("xPed"))) ? p.Field<String>("xPed").Replace(".", ",") : string.Empty : string.Empty,
                                           nItemPed = (p.Table.Columns.Contains("nItemPed")) ? (!string.IsNullOrEmpty(p.Field<String>("nItemPed"))) ? p.Field<String>("nItemPed").Replace(".", ",") : string.Empty : string.Empty,
                                           vICMS = (icmsVal.Table.Columns.Contains("vICMS")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("vICMS"))) ? icmsVal.Field<String>("vICMS").Replace(".", ",") : string.Empty : string.Empty,
                                           pICMS = (icmsVal.Table.Columns.Contains("pICMS")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("pICMS"))) ? icmsVal.Field<String>("pICMS").Replace(".", ",") : string.Empty : string.Empty,
                                           vBC = (icmsVal.Table.Columns.Contains("vBC")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("vBC"))) ? icmsVal.Field<String>("vBC").Replace(".", ",") : string.Empty : string.Empty,
                                           modBC = (icmsVal.Table.Columns.Contains("modBC")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("modBC"))) ? icmsVal.Field<String>("modBC").Replace(".", ",") : string.Empty : string.Empty,
                                           CST = (icmsVal.Table.Columns.Contains("CST")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("CST"))) ? icmsVal.Field<String>("CST").Replace(".", ",") : string.Empty : string.Empty,
                                           orig = (icmsVal.Table.Columns.Contains("orig")) ? (!string.IsNullOrEmpty(icmsVal.Field<String>("orig"))) ? icmsVal.Field<String>("orig").Replace(".", ",") : string.Empty : string.Empty
                                       }).ToList();
                      
                        dtProdDet = ToDataTable<prodDetails>(prodDet);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.InnerException.Message);
                    }

                    this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource("prodDet", dtProdDet));

                    string pathToFile = string.Format("{0}\\Tabelas.htm", Application.StartupPath.ToString());
                    DataSet dsMerge = new DataSet();

                    if (File.Exists(pathToFile))
                    {
                        File.Delete(pathToFile);
                    }

                    File.WriteAllText(pathToFile, tabelas, Encoding.UTF8);
                    this.reportViewer1.LocalReport.EnableExternalImages = true;
                    
                    this.reportViewer1.LocalReport.ReportPath = string.Format("{0}\\{1}", Application.StartupPath.ToString(), "rptDANFE.rdlc");
                    this.reportViewer1.ZoomMode = ZoomMode.PageWidth;
                    this.reportViewer1.LocalReport.SetParameters(parameters);

                    this.reportViewer1.RefreshReport();
                }
            }
        }

        void schemaSet_ValidationEventHandler(object sender, ValidationEventArgs e)
        {
            // MessageBox.Show(string.Format("Itens encontrados: {0}\n{1}", e.Message, e.Severity.ToString()));
        }

        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        public partial class prodDetails
        {
            public Int32 det_id { get; set; }
            public string infAdProd { get; set; }
            public string nItem { get; set; }
            public string cProd { get; set; }
            public string cEAN { get; set; }
            public string xProd { get; set; }
            public string NCM { get; set; }
            public string CFOP { get; set; }
            public string uCom { get; set; }
            public string qCom { get; set; }
            public string vUnCom { get; set; }
            public string vProd { get; set; }
            public string cEANTrib { get; set; }
            public string uTrib { get; set; }
            public string qTrib { get; set; }
            public string vUnTrib { get; set; }
            public string indTot { get; set; }
            public string xPed { get; set; }
            public string nItemPed { get; set; }
            public string vICMS { get; set; }
            public string pICMS { get; set; }
            public string vBC { get; set; }
            public string modBC { get; set; }
            public string CST { get; set; }
            public string orig { get; set; }

            public prodDetails()
            {
                det_id = int.MinValue;
                infAdProd = nItem = cProd = cEAN = xProd = NCM = CFOP = uCom = qCom 
                    = vUnCom = vProd = cEANTrib = uTrib = qTrib 
                    = vUnTrib = indTot = xPed = nItemPed = vICMS = pICMS 
                    = vBC = modBC = CST = orig = string.Empty;
            }
        }

        public partial class vol
        {
            public string qVol { get; set; }
            public string esp { get; set; }
            public string marca { get; set; }
            public string nVol { get; set; }
            public string pesoL { get; set; }
            public string pesoB	{ get; set; }
            public string transp_Id { get; set; }

            public vol()
            {
                qVol = esp = marca = nVol = transp_Id = pesoB = pesoL = string.Empty;
            }
        }

        public partial class ICMS
        {
            public string orig { get; set; }
            public string CST { get; set; }
            public string modBC { get; set; }
            public string vBC { get; set; }
            public string pICMS { get; set; }
            public string vICMS { get; set; }
            public Nullable<int> ICMS_Id { get; set; }

            public ICMS()
            {
                orig = CST = modBC = vBC = pICMS = vICMS = string.Empty;
                ICMS_Id = null;
            }
        }
    }
}

