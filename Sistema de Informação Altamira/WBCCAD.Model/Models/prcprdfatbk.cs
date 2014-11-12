using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prcprdfatbk
    {
        public string Prcprdcab_descricao { get; set; }
        public string Produto { get; set; }
        public string Sigla_Cor { get; set; }
        public string variavel { get; set; }
        public Nullable<double> Preco { get; set; }
        public Nullable<double> PRCPRD_ADICIONAL { get; set; }
        public Nullable<double> LP_PRCPRD_COMPRIMENTO { get; set; }
        public Nullable<double> LP_PRCPRD_ALTURA { get; set; }
        public Nullable<double> LP_PRCPRD_PROFUNDIDADE { get; set; }
    }
}
