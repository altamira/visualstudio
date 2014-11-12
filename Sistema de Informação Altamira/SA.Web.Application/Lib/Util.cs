using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Data.SqlClient;
using System.Data;

namespace SA.Web.Application.Lib
{
    public static class Util
    {
        public static bool ValidaDataDropDownList(DropDownList Dia, DropDownList Mes, DropDownList Ano, out DateTime Data)
        {
            if (!DateTime.TryParse(Dia.SelectedValue + "/" + Mes.SelectedValue + "/" + Ano.SelectedValue, out Data))
            {
                Dia.BackColor = Color.Red;
                Mes.BackColor = Color.Red;
                Ano.BackColor = Color.Red;
                Dia.ForeColor = Color.White;
                Mes.ForeColor = Color.White;
                Ano.ForeColor = Color.White;

                return false;
            }
            else
            {
                Dia.BackColor = Color.White;
                Mes.BackColor = Color.White;
                Ano.BackColor = Color.White;

                Dia.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                Mes.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
                Ano.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                return true;
            }
        }

        public static bool ValidaNumeroTextBox(TextBox NumeroTextBox, out int Numero)
        {
            Numero = 0;

            if (NumeroTextBox.Text.Trim().Length < 5 || !int.TryParse(NumeroTextBox.Text.Trim(), out Numero))
            {
                NumeroTextBox.BackColor = Color.Red;
                NumeroTextBox.ForeColor = Color.White;

                return false;
            }
            else
            {
                NumeroTextBox.BackColor = Color.White;
                NumeroTextBox.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                return true;
            }
        }
        public static bool ValidaNomeTextBox(TextBox NomeTextBox)
        {
            if (NomeTextBox.Text.Trim().Length > 1)
            {
                NomeTextBox.BackColor = Color.White;
                NomeTextBox.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");

                return true;
            }
            else
            {
                NomeTextBox.BackColor = Color.Red;
                NomeTextBox.ForeColor = Color.White;

                return false;
            }
        }

        public static void AtualizaTitulo(Label Titulo, string Mensagem, bool Alerta)
        {
            Titulo.Text = Mensagem;

            if (Alerta)
                Titulo.ForeColor = Color.Red;
            else
                Titulo.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3366CC");
        }
    }



}