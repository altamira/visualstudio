using System;
using System.Collections.Generic;

namespace WpfApplication3.Models
{
    public partial class CLIENTE
    {
        public CLIENTE()
        {
            this.PEDIDOes = new List<PEDIDO>();
        }

        public int CODIGO { get; set; }
        public string NOME { get; set; }
        public virtual ICollection<PEDIDO> PEDIDOes { get; set; }
    }
}
