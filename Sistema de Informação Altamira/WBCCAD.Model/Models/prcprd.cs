using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prcprd
    {
        public string Prcprdcab_descricao { get; set; }
        public string Produto { get; set; }
        public string Sigla_Cor { get; set; }
        public Nullable<double> Preco { get; set; }
        public Nullable<double> Ipi { get; set; }
        public Nullable<double> Icms { get; set; }
        public Nullable<decimal> PRCPRD_ADICIONAL { get; set; }
        public Nullable<decimal> LP_PRCPRD_COMPRIMENTO { get; set; }
        public Nullable<decimal> LP_PRCPRD_ALTURA { get; set; }
        public Nullable<decimal> LP_PRCPRD_PROFUNDIDADE { get; set; }
        public Nullable<decimal> PRECOFAB { get; set; }
        public Nullable<decimal> PRECOFABADC { get; set; }
        public Nullable<decimal> PRECOFABADCCMP { get; set; }
        public Nullable<decimal> PRECOFABADCALT { get; set; }
        public Nullable<decimal> PRECOFABADCPRF { get; set; }
    }
}
