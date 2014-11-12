using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cabos_eletro_acessorios
    {
        public bool dep_dia1 { get; set; }
        public bool dep_dia2 { get; set; }
        public bool qtde_por_compr { get; set; }
        public Nullable<int> multiplo { get; set; }
        public Nullable<int> qtde_p_linha { get; set; }
        public string chave { get; set; }
        public Nullable<int> compr_min_p_incluir { get; set; }
        public bool valido_somente_uc { get; set; }
        public string desenho { get; set; }
    }
}
