using System;
using System.Collections.Generic;

namespace WpfApplication3.Models
{
    public partial class SITUACAO
    {
        public SITUACAO()
        {
            this.SITUACAO_PEDIDO = new List<SITUACAO_PEDIDO>();
        }

        public int CODIGO { get; set; }
        public string DESCRICAO { get; set; }
        public virtual ICollection<SITUACAO_PEDIDO> SITUACAO_PEDIDO { get; set; }
    }
}
