using System;
using System.Collections.Generic;

namespace WpfApplication3.Models
{
    public partial class SITUACAO_PEDIDO
    {
        public int PEDIDO_ID { get; set; }
        public int SITUACAO_ID { get; set; }
        public System.DateTime DT_SITUACAO { get; set; }
        public virtual PEDIDO PEDIDO { get; set; }
        public virtual SITUACAO SITUACAO { get; set; }
    }
}
