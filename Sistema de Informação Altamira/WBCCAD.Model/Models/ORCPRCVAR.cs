using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class ORCPRCVAR
    {
        public int idOrcPrcVar { get; set; }
        public string numeroOrcamento { get; set; }
        public string VARIAVEL { get; set; }
        public string PRODUTO { get; set; }
        public string COR { get; set; }
        public Nullable<decimal> PRECO { get; set; }
        public Nullable<decimal> LISTA { get; set; }
        public Nullable<decimal> ADICIONAL { get; set; }
        public Nullable<decimal> COMPRIMENTO { get; set; }
        public Nullable<decimal> ALTURA { get; set; }
        public Nullable<decimal> PROFUNDIDADE { get; set; }
    }
}
