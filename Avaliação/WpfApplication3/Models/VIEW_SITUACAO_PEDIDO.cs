using System;
using System.Collections.Generic;

namespace WpfApplication3.Models
{
    public partial class VIEW_SITUACAO_PEDIDO
    {
        public int NUMERO { get; set; }
        public System.DateTime DT_EMISSAO { get; set; }
        public System.DateTime DT_ENTREGA { get; set; }
        public string NOME { get; set; }
        public Nullable<System.DateTime> DT_SITUACAO { get; set; }
        public string DESCRICAO { get; set; }
    }
}
