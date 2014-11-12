﻿using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;
using System.Drawing;
using ALTANet.Lib;

namespace WebApplication1
{
    public partial class orcamentos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!ALTANet.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
            {
                DiaBottom_Click(this, new ImageClickEventArgs(0, 0));

                DiaPeriodoInicialDropDown.SelectedValue = DateTime.Now.Day.ToString();
                MesPeriodoInicialDropDown.SelectedValue = DateTime.Now.Month.ToString();
                AnoPeriodoInicialDropDown.SelectedValue = DateTime.Now.Year.ToString();

                DiaPeriodoFinalDropDown.SelectedValue = DateTime.Now.Day.ToString();
                MesPeriodoFinalDropDown.SelectedValue = DateTime.Now.Month.ToString();
                AnoPeriodoFinalDropDown.SelectedValue = DateTime.Now.Year.ToString();
            }
            else
            {
                NumeroTextBox.BackColor = Color.White;
                NumeroTextBox.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                NomeTextBox.BackColor = Color.White;
                NomeTextBox.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                DiaPeriodoInicialDropDown.BackColor = Color.White;
                MesPeriodoInicialDropDown.BackColor = Color.White;
                AnoPeriodoInicialDropDown.BackColor = Color.White;

                DiaPeriodoFinalDropDown.BackColor = Color.White;
                MesPeriodoFinalDropDown.BackColor = Color.White;
                AnoPeriodoFinalDropDown.BackColor = Color.White;

                DiaPeriodoInicialDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                MesPeriodoInicialDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                AnoPeriodoInicialDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                DiaPeriodoFinalDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                MesPeriodoFinalDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                AnoPeriodoFinalDropDown.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
            }
        }

        protected void NomeButtom_Click(object sender, ImageClickEventArgs e)
        {
            NumeroTextBox.Text = "";

            if (Util.ValidaNomeTextBox(NomeTextBox))
            {
                Util.AtualizaTitulo(TituloLabel, "Orçamentos com o nome do cliente iniciando com '" + NomeTextBox.Text.Trim() + "'", false);

                SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                Connection.Open();

                SqlCommand Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;

                Command.CommandText = "[Representante].[Busca de Orçamentos por Nome]";

                Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
                Command.Parameters.Add(new SqlParameter("@Nome", SqlDbType.NVarChar, 50)).Value = NomeTextBox.Text.Trim();

                SqlDataReader DataReader = Command.ExecuteReader();

                OrcamentosGridView.DataSource = DataReader;
                OrcamentosGridView.DataBind();

                DataReader.Close();

                Connection.Close();
            }
            else
            {
                Util.AtualizaTitulo(TituloLabel, "Nome do cliente deve ter no mínimo 2 caracteres !", true);
            }
        }

        protected void NumeroButtom_Click(object sender, ImageClickEventArgs e)
        {
            NomeTextBox.Text = "";

            int Numero = 0;

            if (Util.ValidaNumeroTextBox(NumeroTextBox, out Numero))
            {
                Util.AtualizaTitulo(TituloLabel, "Orçamento número " + NumeroTextBox.Text, false);

                SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                Connection.Open();

                SqlCommand Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;

                Command.CommandText = "[Representante].[Busca de Orçamentos por Número]";

                Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
                Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = int.TryParse(NumeroTextBox.Text.Trim(), out Numero) ? Numero : 0;

                SqlDataReader DataReader = Command.ExecuteReader();

                OrcamentosGridView.DataSource = DataReader;
                OrcamentosGridView.DataBind();

                DataReader.Close();

                Connection.Close();
            }
            else 
            {
                Util.AtualizaTitulo(TituloLabel, "Número inválido. O número do orçamento tem no mínimo 5 digitos !", true);
            }

        }

        protected void MesButtom_Click(object sender, ImageClickEventArgs e)
        {
            NumeroTextBox.Text = "";
            NomeTextBox.Text = "";

            Util.AtualizaTitulo(TituloLabel, "Orçamentos deste Mês", false);

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Busca de Orçamentos do Mes]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());

            SqlDataReader DataReader = Command.ExecuteReader();

            OrcamentosGridView.DataSource = DataReader;
            OrcamentosGridView.DataBind();

            DataReader.Close();
            Connection.Close();
        }

        protected void SemanaButtom_Click(object sender, ImageClickEventArgs e)
        {
            NumeroTextBox.Text = "";
            NomeTextBox.Text = "";

            Util.AtualizaTitulo(TituloLabel, "Orçamentos desta Semana", false);

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Busca de Orçamentos da Semana]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());

            SqlDataReader DataReader = Command.ExecuteReader();

            OrcamentosGridView.DataSource = DataReader;
            OrcamentosGridView.DataBind();

            DataReader.Close();
            Connection.Close();
        }

        protected void DiaBottom_Click(object sender, ImageClickEventArgs e)
        {
            NumeroTextBox.Text = "";
            NomeTextBox.Text = "";

            Util.AtualizaTitulo(TituloLabel, "Orçamentos de Hoje", false);

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Busca de Orçamentos do Dia]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());

            SqlDataReader DataReader = Command.ExecuteReader();

            OrcamentosGridView.DataSource = DataReader;
            OrcamentosGridView.DataBind();

            DataReader.Close();
            Connection.Close();
        }

        protected void PeriodoButtom_Click(object sender, ImageClickEventArgs e)
        {
            NumeroTextBox.Text = "";
            NomeTextBox.Text = "";

            DateTime DataInicial, DataFinal;

            if (Util.ValidaDataDropDownList(DiaPeriodoInicialDropDown, MesPeriodoInicialDropDown, AnoPeriodoInicialDropDown, out DataInicial) &&
                Util.ValidaDataDropDownList(DiaPeriodoFinalDropDown, MesPeriodoFinalDropDown, AnoPeriodoFinalDropDown, out DataFinal))
            {
                Util.AtualizaTitulo(TituloLabel, String.Format("Orçamentos no período de {0} à {1}", DataInicial.ToShortDateString(), DataFinal.ToShortDateString()), false);

                SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                Connection.Open();

                SqlCommand Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;

                Command.CommandText = "[Representante].[Busca de Orçamentos por Período]";

                Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
                Command.Parameters.Add(new SqlParameter("@DataInicial", SqlDbType.Date)).Value = DataInicial;
                Command.Parameters.Add(new SqlParameter("@DataFinal", SqlDbType.Date)).Value = DataFinal;

                SqlDataReader DataReader = Command.ExecuteReader();

                OrcamentosGridView.DataSource = DataReader;
                OrcamentosGridView.DataBind();

                DataReader.Close();
                Connection.Close();
            }
            else
            {
                Util.AtualizaTitulo(TituloLabel, "Período inválido !", true);
            }
        }

    }
}