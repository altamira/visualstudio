using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcCalDet
    {
        public int idOrcCalDet { get; set; }
        public string TipoCalculo { get; set; }
        public Nullable<int> idGrupo { get; set; }
        public string Valor { get; set; }
        public Nullable<decimal> TotalLista { get; set; }
        public Nullable<decimal> TotalVenda { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
