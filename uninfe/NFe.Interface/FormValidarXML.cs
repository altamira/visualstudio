﻿using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using NFe.Components;
using NFe.Certificado;
using NFe.Settings;

namespace NFe.Interface
{
    public partial class FormValidarXML : Form
    {
        private int Emp;
        ArrayList empresa = new ArrayList();

        public FormValidarXML()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.openFileDialog_arqxml.FileName = "";
            this.openFileDialog_arqxml.RestoreDirectory = true; //Para não mudar o diretório corrente da aplicação. Wandrey 06/08/2008
            this.openFileDialog_arqxml.Filter = "Arquivos XML|*.xml";
            if (this.openFileDialog_arqxml.ShowDialog() == DialogResult.OK)
            {
                this.textBox_arqxml.Text = this.openFileDialog_arqxml.FileName.ToString();

                NFe.Validate.ValidarXML validarXML = new NFe.Validate.ValidarXML(this.textBox_arqxml.Text, Empresa.Configuracoes[Emp].UFCod);
                this.textBox_tipoarq.Text = validarXML.TipoArqXml.cRetornoTipoArq;
            }

            this.textBox_resultado.Text = "";
        }

        private void toolStripButton_validar_Click(object sender, EventArgs e)
        {
            this.textBox_resultado.Text = "";
            if (this.textBox_arqxml.Text == "")
            {
                this.textBox_resultado.Text = "Arquivo não encontrado.";
                return;
            }

            //Copiar o arquivo XML para temporários para assinar e depois vou validar o que está nos temporários
            FileInfo oArquivo = new FileInfo(this.textBox_arqxml.Text);
            string cArquivo = System.IO.Path.GetTempPath() + Functions.ExtrairNomeArq(this.textBox_arqxml.Text, ".xml");

            FileInfo oArqDestino = new FileInfo(cArquivo);

            if (File.Exists(cArquivo)) //Deletar o arquivo antes de copiar se existir na pasta de temporários
            {
                oArqDestino.Delete();
            }

            oArquivo.CopyTo(cArquivo);

            //Detectar o tipo do arquivo
            NFe.Validate.ValidarXML validarXML = new NFe.Validate.ValidarXML(cArquivo, Empresa.Configuracoes[Emp].UFCod);

            //Assinar o arquivo XML copiado para a pasta TEMP
            bool lValidar = false;
            AssinaturaDigital oAD = new AssinaturaDigital();
            try
            {
                oAD.Assinar(cArquivo, Emp, Empresa.Configuracoes[Emp].UFCod);
                lValidar = true;
            }
            catch (Exception ex)
            {
                lValidar = false;
                this.textBox_tipoarq.Text = validarXML.TipoArqXml.cRetornoTipoArq;
                this.textBox_resultado.Text = "Ocorreu um erro ao tentar assinar o XML: \r\n\r\n" + ex.Message;
            }

            if (lValidar == true)
            {
                //Validar o arquivo
                if (validarXML.TipoArqXml.nRetornoTipoArq >= 1 && validarXML.TipoArqXml.nRetornoTipoArq <= SchemaXML.MaxID)
                {
                    validarXML.Validar(cArquivo);
                    if (string.IsNullOrEmpty(validarXML.TipoArqXml.cArquivoSchema))
                    {
                        this.textBox_resultado.Text = "XML não possui schema de validação, sendo assim não é possível validar XML;";
                    }
                    else if (validarXML.Retorno == 0)
                    {
                        this.textBox_resultado.Text = "Arquivo validado com sucesso;";
                    }
                    else
                    {
                        this.textBox_resultado.Text = "XML INCONSISTENTE!\r\n\r\n" + validarXML.RetornoString;
                    }
                }
                else
                {
                    this.textBox_tipoarq.Text = validarXML.TipoArqXml.cRetornoTipoArq;
                    this.textBox_resultado.Text = "XML INCONSISTENTE!\r\n\r\n" + validarXML.TipoArqXml.cRetornoTipoArq;
                }
            }

            oArqDestino.Delete();
        }

        private void cbEmpresa_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateDetalheForm();
        }

        /// <summary>
        /// Popular detalhes do form de acordo com a empresa selecionada
        /// </summary>
        private void PopulateDetalheForm()
        {
            string cnpj = ((ComboElem)(new System.Collections.ArrayList(empresa))[cbEmpresa.SelectedIndex]).Valor;
            Emp = Empresa.FindConfEmpresaIndex(cnpj);
        }

        #region PopulateCbEmpresa()
        /// <summary>
        /// Popular a ComboBox das empresas
        /// </summary>
        /// <remarks>
        /// Observações: Tem que popular separadamente do Método Populate() para evitar ficar recarregando na hora que selecionamos outra empresa
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 30/07/2010
        /// </remarks>
        private void PopulateCbEmpresa()
        {
            try
            {
                empresa = Auxiliar.CarregaEmpresa();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            if (empresa.Count > 0)
            {
                cbEmpresa.DataSource = empresa;
                cbEmpresa.DisplayMember = "Nome";
                cbEmpresa.ValueMember = "Valor";
            }
        }
        #endregion

        private void ValidarXML_Load(object sender, EventArgs e)
        {
            PopulateCbEmpresa();
        }

        private void textBox_arqxml_Validating(object sender, CancelEventArgs e)
        {
            NFe.Validate.ValidarXML validarXML = new NFe.Validate.ValidarXML(this.textBox_arqxml.Text, Empresa.Configuracoes[Emp].UFCod);
            this.textBox_tipoarq.Text = validarXML.TipoArqXml.cRetornoTipoArq;
        }
    }
}