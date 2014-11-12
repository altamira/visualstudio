using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SA.Data.Models.Financeiro.Bancos
{
    public class Conta
    {
        private string banco;
        private string agencia;
        private string numero;

        public Conta(string Banco)
        {
            banco = Banco;
        }

        public string Banco
        {
            get { return banco; }
            set { banco = value; }
        }

        public string Agencia
        {
            get { return agencia; }
            set { agencia = value; }
        }

        public string Numero
        {
            get { return numero; }
            set { numero = value; }
        }
    }

}
