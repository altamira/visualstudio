using System;
using System.Collections.Generic;

namespace WpfApplication3.Models
{
    public partial class PEDIDO
    {
        public PEDIDO()
        {
            this.SITUACAO_PEDIDO = new List<SITUACAO_PEDIDO>();
        }

        public int NUMERO { get; set; }
        public int CLIENTE_ID { get; set; }
        public System.DateTime DT_EMISSAO { get; set; }
        public System.DateTime DT_ENTREGA { get; set; }
        public virtual CLIENTE CLIENTE { get; set; }
        public virtual ICollection<SITUACAO_PEDIDO> SITUACAO_PEDIDO { get; set; }
    }
}
