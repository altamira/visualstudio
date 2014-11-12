using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Globalization;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Model
{
    public partial class Transaction : Base
    {

        #region "Variables"

        private int _id;
        private int _AccountId;
        private DateTime _data;
        private string _cheque;
        private string _descricao;
        private decimal _valor;
        private TRANSACTIONTYPE _TRANSACTIONTYPE;
        private bool _liquidated;
        private decimal balance;
        private Account _Account;
       
        #endregion
        
        #region "Properties"

        public int Id {
            get { return _id ;}
            set {
                _id = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Id"));  
                } 
        }

        public int AccountId
        {
            get { return _AccountId ;}
            set {
                _AccountId = value;
                OnPropertyChanged(new PropertyChangedEventArgs("AccountId"));}
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

        public TRANSACTIONTYPE TRANSACTIONTYPE
        {
            get
            {
                return _TRANSACTIONTYPE;
            }
            set
            {
                _TRANSACTIONTYPE = value;
                OnPropertyChanged(new PropertyChangedEventArgs("TRANSACTIONTYPE"));
            }
        }

        public bool liquidated
        {
            get { return _liquidated;}
            set {
                _liquidated = value;
                OnPropertyChanged(new PropertyChangedEventArgs("liquidated"));}
        }

        [NotMappedAttribute]
        public decimal Balance
        {
            get { return balance; }
            set
            {
                balance = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Balance"));
            }
        }

        public virtual Account Account {
            get { return _Account ;}
            set {
                _Account = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Account"));
            }
        }

        #endregion

        #region "Contrutores"

        public Transaction()
        {
            this._TRANSACTIONTYPE = TRANSACTIONTYPE.Debito;
            this._data = DateTime.Now;
        }

        #endregion

        #region "Métodos"

        #endregion
    }
}
