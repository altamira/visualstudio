using Microsoft.Reporting.WinForms;
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
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Reports
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
            List<ReportParameter> parameters = new List<ReportParameter>();

            parameters.Add(new ReportParameter("rptImagePath", string.Format("file://{0}\\{1}", Application.StartupPath.ToString(), "logotipos\\logo_altamira.png")));

            string myXMLFile = string.Format("{0}\\{1}", Application.StartupPath.ToString(), "GP_NFe_01_000008452_exp.xml");

            DataSet ds = new DataSet();

            FileStream fso = new FileStream(myXMLFile, FileMode.Open);

            try
            {
                ds.ReadXml(fso);

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

                tabelas += "</body></html>";

                this.reportViewer1.LocalReport.DataSources.Add(new ReportDataSource("mergedProdDet", UniteDataTable(ds.Tables["prod"], ds.Tables["det"], "mergedProdDet")));

                string pathToFile = string.Format("{0}\\Tabelas.htm", Application.StartupPath.ToString());
                
                if (File.Exists(pathToFile))
                {
                    File.Delete(pathToFile);
                }

                File.WriteAllText(pathToFile, tabelas, Encoding.ASCII);

                this.reportViewer1.LocalReport.EnableExternalImages = true;

                this.reportViewer1.LocalReport.ReportPath = string.Format("{0}\\{1}", Application.StartupPath.ToString(), "rptDANFE.rdlc");
                this.reportViewer1.LocalReport.SetParameters(parameters);

                this.reportViewer1.RefreshReport();

            }
            catch(Exception ex)
            {
            }
       }

        /// </summary>      
        /// <param name="dt1">Table1</param>      
        /// <param name="dt2">Table2</param>      
        /// <param name="DTName">Novo nome de tabela</param>      
        /// <returns></returns>
        private DataTable UniteDataTable(DataTable dt1, DataTable dt2, string DTName)
        {
            DataTable dt3 = dt1.Clone();
            for (int i = 0; i < dt2.Columns.Count; i++)
            {
                if (!dt3.Columns.Contains(dt2.Columns[i].ColumnName))
                    dt3.Columns.Add(dt2.Columns[i].ColumnName);
            }
            
            object[] obj = new object[dt3.Columns.Count];

            for (int i = 0; i < dt1.Rows.Count; i++)
            {
                dt1.Rows[i].ItemArray.CopyTo(obj, 0);
                dt3.Rows.Add(obj);
            }

            if (dt1.Rows.Count >= dt2.Rows.Count)
            {
                for (int i = 0; i < dt2.Rows.Count; i++)
                {
                    for (int j = 0; j < dt2.Columns.Count; j++)
                    {
                        foreach (DataColumn dc in dt1.Columns)
                            if (dc.ColumnName != dt2.Columns[i].ColumnName)
                                dt3.Rows[i][dt2.Columns[j].ColumnName] = dt2.Rows[i][j].ToString();
                    }
                }
            }
            else
            {
                DataRow dr3;
                for (int i = 0; i < dt2.Rows.Count - dt1.Rows.Count; i++)
                {
                    dr3 = dt3.NewRow();
                    dt3.Rows.Add(dr3);
                }
                for (int i = 0; i < dt2.Rows.Count; i++)
                {
                    for (int j = 0; j < dt2.Columns.Count; j++)
                    {
                        dt3.Rows[i][j + dt1.Columns.Count] = dt2.Rows[i][j].ToString();
                    }
                }
            }
            dt3.TableName = DTName;
            return dt3;
        }  
    }
}