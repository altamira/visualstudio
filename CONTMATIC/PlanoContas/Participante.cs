using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace CONTMATIC
{
    public class Participante : INotifyPropertyChanged
    {
        private bool selecionado;

        public bool Selecionado
        {
            get { return selecionado; }
            set { selecionado = value; OnPropertyChanged("Selecionado"); }
        }

        private bool habilitado;

        public bool Habilitado
        {
            get { return habilitado; }
            set { habilitado = value; }
        }
        
        private string cnpj;

        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }

        private string nome;

        public string Nome
        {
            get { return nome; }
            set { nome = value; }
        }

        private string tipo;


        public string Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }

        private string pessoa;

        public string Pessoa
        {
            get { return pessoa; }
            set { pessoa = value; }
        }

        private string cccliente;

        public string CCCliente
        {
            get { return cccliente; }
            set { cccliente = value; }
        }

        private string ccfornecedor;

        public string CCFornecedor
        {
            get { return ccfornecedor; }
            set { ccfornecedor = value; }
        }

        private string situacao;

        public string Situacao
        {
            get { return situacao; }
            set { situacao = value; OnPropertyChanged("Situacao"); }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged(string caller)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(caller));
            }
        }

    }
}
