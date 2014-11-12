using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace CONTMATIC
{
    public class ContaContabil : INotifyPropertyChanged
    {
        private bool selecionado;

        public bool Selecionado
        {
            get { return selecionado; }
            set { selecionado = value; OnPropertyChanged("Selecionado"); }
        }
        
        private string conta;

        public string Conta
        {
            get { return conta; }
            set { conta = value; }
        }

        private string contaantiga;

        public string ContaAntiga
        {
            get { return contaantiga; }
            set { contaantiga = value; }
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

        private int reduzida;

        public int Reduzida
        {
            get { return reduzida; }
            set { reduzida = value; }
        }

        private int reduzidaantiga;

        public int ReduzidaAntiga
        {
            get { return reduzidaantiga; }
            set { reduzidaantiga = value; }
        }

        private string pessoa;

        public string Pessoa
        {
            get { return pessoa; }
            set { pessoa = value; }
        }

        private string situacao;

        public string Situacao
        {
            get { return situacao; }
            set { situacao = value; OnPropertyChanged("Situacao"); }
        }

        private bool habilitado;

        public bool Habilitado
        {
            get { return habilitado; }
            set { habilitado = value; }
        }

        //private bool cliente;

        //public bool Cliente
        //{
        //    get { return cliente; }
        //    set { cliente = value; }
        //}

        //private bool fornecedor;

        //public bool Fornecedor
        //{
        //    get { return fornecedor; }
        //    set { fornecedor = value; }
        //}

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
