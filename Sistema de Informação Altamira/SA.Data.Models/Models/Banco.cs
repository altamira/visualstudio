using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;

namespace SA.Data.Models
{
    public partial class Banco
    {
        public Banco()
        {
            this.Agencias = new List<Agencia>();
        }
        public int Id { get; set; }
        public int Numero { get; set; }
        public string Nome { get; set; }
        public virtual ICollection<Agencia> Agencias { get; set; }
    }
}
