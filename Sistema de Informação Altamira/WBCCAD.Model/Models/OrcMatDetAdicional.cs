using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcMatDetAdicional
    {
        public int idOrcMatDetAdicional { get; set; }
        public Nullable<int> idOrcMatDet { get; set; }
        public string chave { get; set; }
        public Nullable<decimal> @base { get; set; }
        public Nullable<double> fator { get; set; }
        public Nullable<double> redutor { get; set; }
        public Nullable<decimal> valor { get; set; }
        public Nullable<int> markup { get; set; }
        public string formula { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
