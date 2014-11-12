using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace SA.Data.Models
{
    public partial class Conta: INotifyPropertyChanged
    {
        #region Variáveis

        private decimal _saldo;
        private decimal _saldoconferido;
        private decimal _saldofinal;

        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Propriedades


        public int Id { get; set; }
        public int Agencia { get; set; }
        public string Numero { get; set; }
        public decimal Saldo
        {
            get
            {
                return _saldo;
            }
            set
            {
                _saldo = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Saldo"));
                SaldoConferido = _saldo;
            }
        }

        [NotMappedAttribute]
        public decimal SaldoConferido
        {
            get
            {
                return _saldoconferido;
            }
            set
            {
                _saldoconferido = value;
                OnPropertyChanged(new PropertyChangedEventArgs("SaldoConferido"));
            }
        }

        public virtual Agencia Agencia1 { get; set; }
        public virtual ICollection<Movimento> Movimentos { get; set; }


        #endregion

        #region Construtores

        public Conta()
        {
            this.Movimentos = new List<Movimento>();
        }

        #endregion

        #region Métodos

        public void OnPropertyChanged(PropertyChangedEventArgs e)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, e);
            }
        }

        #endregion

    }
}
