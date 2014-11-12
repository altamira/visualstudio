using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tblDesconto
    {
        public int idTblDesconto { get; set; }
        public Nullable<decimal> DescontoFaixa { get; set; }
        public Nullable<decimal> DescontoComissao { get; set; }
    }
}
