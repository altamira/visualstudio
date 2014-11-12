using System;
using System.Collections.Generic;

namespace SA.Data.Models
{
    public partial class Agencia
    {
        public Agencia()
        {
            this.Contas = new List<Conta>();
        }

        public int Id { get; set; }
        public int Banco { get; set; }
        public string Numero { get; set; }
        public string Gerente { get; set; }
        public string Telefone { get; set; }
        public virtual Banco Banco1 { get; set; }
        public virtual ICollection<Conta> Contas { get; set; }
    }
}
