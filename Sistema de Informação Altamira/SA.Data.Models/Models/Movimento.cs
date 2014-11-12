using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Globalization;

namespace SA.Data.Models
{
    public enum OPERACAO : byte
    {
        Debito = 0,
        Credito = 1 
    }

    public partial class Movimento : INotifyPropertyChanged
    {

        #region "Variáveis"
        private int _id;
        private int _conta;
        private DateTime _data;
        private string _cheque;
        private string _descricao;
        private decimal _valor;
        private OPERACAO _operacao;
        private bool _liquidado;
        private decimal _saldo;
        private Conta _conta1;
       
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        
        #region "Propriedades"
        public int Id {
            get { return _id ;}
            set {
                _id = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Id"));  
                } 
        }
        public int Conta
        {
            get { return _conta ;}
            set {
                _conta = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Conta"));}
        }
        public System.DateTime Data
        {
            get { return _data;}
            set {
                _data = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Data"));}
        }
        public string Cheque
        {
            get { return _cheque;}
            set {
                _cheque = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Cheque"));
            }
        }
        public string Descricao
        {
            get { return _descricao;}
            set {
                _descricao = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Descricao"));}
        }
        public decimal Valor
        {
            get { return _valor;}
            set 
            {
                _valor = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Valor"));
            }
        }

        public OPERACAO Operacao
        {
            get
            {
                return _operacao;
            }
            set
            {
                _operacao = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Operacao"));
            }
        }

        public bool Liquidado
        {
            get { return _liquidado;}
            set {
                _liquidado = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Liquidado"));}
        }

        [NotMappedAttribute]
        public decimal Saldo
        {
            get { return _saldo; }
            set
            {
                _saldo = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Saldo"));
            }
        }

        public virtual Conta Conta1 {
            get { return _conta1 ;}
            set {
                _conta1 = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Conta1"));}
        }

        #endregion

        #region "Contrutores"
        public Movimento()
        {
            this._operacao = OPERACAO.Debito;
            this._data = DateTime.Now;
        }

        #endregion

        #region "Métodos"

        public void OnPropertyChanged(PropertyChangedEventArgs e)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, e);

                if (this.Conta1 != null)
                {
                    if (e.PropertyName == "Liquidado")
                    {
                        if (this.Operacao == OPERACAO.Debito)
                            this.Conta1.SaldoConferido += this.Liquidado ? this.Valor * -1 : this.Valor;
                        else
                            this.Conta1.SaldoConferido += this.Liquidado ? this.Valor : this.Valor * -1;
                    }

                    if (e.PropertyName == "Liquidado" || e.PropertyName == "Operacao" || e.PropertyName == "Valor")
                    {
                        decimal saldo = this.Conta1.Saldo;

                        foreach (Movimento m in this.Conta1.Movimentos)
                        {
                            saldo += m.Operacao == OPERACAO.Debito ? m.Valor * -1 : m.Valor;

                            m.Saldo = saldo;
                        }

                    }
                }

            }
        }
        #endregion


    }
}
