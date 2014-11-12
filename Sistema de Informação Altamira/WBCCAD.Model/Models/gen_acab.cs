using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gen_acab
    {
        public int indice { get; set; }
        public string nome { get; set; }
        public string sigla { get; set; }
        public string GenGrpPrecoCodigo { get; set; }
        public Nullable<bool> TRAVAR_REPRESENTANTE { get; set; }
        public string cor_cad { get; set; }
        public Nullable<bool> exibirOrcamento { get; set; }
        public string integracao { get; set; }
    }
}
