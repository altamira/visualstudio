using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace CONTMATIC
{
    public class LancamentoFluxoCaixa : INotifyPropertyChanged
    {
        private bool selecionado;

        public bool Selecionado
        {
            get { return selecionado; }
            set { selecionado = value; OnPropertyChanged("Selecionado"); }
        }

        private int titulo;

        public int Titulo
        {
            get { return titulo; }
            set { titulo = value; }
        }

        private string documento;

        public string Documento
        {
            get { return documento; }
            set { documento = value; }
        }

        private string pedido;

        public string Pedido
        {
            get { return pedido; }
            set { pedido = value; }
        }

        private string origem;

        public string Origem
        {
            get { return origem; }
            set { origem = value; }
        }

        private DateTime? emissao;

        public DateTime? Emissao
        {
            get { return emissao; }
            set { emissao = value; }
        }

        private DateTime? vencimento;

        public DateTime? Vencimento
        {
            get { return vencimento; }
            set { vencimento = value; }
        }

        private DateTime? pagamento;

        public DateTime? Pagamento
        {
            get { return pagamento; }
            set { pagamento = value; }
        }

        private DateTime? faturamento;

        public DateTime? Faturamento
        {
            get { return faturamento; }
            set { faturamento = value; }
        }
        
        private string cnpj;

        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }

        private string titular;

        public string Titular
        {
            get { return titular; }
            set { titular = value; }
        }

        private string tipo;

        public string Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }

        private string banco;

        public string Banco
        {
            get { return banco; }
            set { banco = value; }
        }
        
        private string parcela;

        public string Parcela
        {
            get { return parcela; }
            set { parcela = value; }
        }

        private string parcelas;

        public string Parcelas
        {
            get { return parcelas; }
            set { parcelas = value; }
        }

        private decimal valor;

        public decimal Valor
        {
            get { return valor; }
            set { valor = value; }
        }

        private float valorbaixa;

        public float ValorBaixa
        {
            get { return valorbaixa; }
            set { valorbaixa = value; }
        }

        private int lancamento;

        public int Lancamento
        {
            get { return lancamento; }
            set { lancamento = value; OnPropertyChanged("Lancamento"); }
        }

        private int sequencia;

        public int Sequencia
        {
            get { return sequencia; }
            set { sequencia = value; OnPropertyChanged("Sequencia"); }
        }

        private string debito;

        public string Debito
        {
            get { return debito; }
            set { debito = value; OnPropertyChanged("Debito"); }
        }

        private string credito;

        public string Credito
        {
            get { return credito; }
            set { credito = value; OnPropertyChanged("Credito"); }
        }
        
        private string situacao;

        public string Situacao
        {
            get { return situacao; }
            set { situacao = value; OnPropertyChanged("Situacao"); }
        }

        private string observacao;

        public string Observacao
        {
            get { return observacao; }
            set { observacao = value; }
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
