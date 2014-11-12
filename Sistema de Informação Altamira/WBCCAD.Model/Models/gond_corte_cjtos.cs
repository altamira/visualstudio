using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_corte_cjtos
    {
        public string nome_conjunto { get; set; }
        public Nullable<int> qtde_niveis { get; set; }
        public Nullable<int> tipo_ins { get; set; }
        public string pos_ins { get; set; }
        public Nullable<int> pos_ins_valor { get; set; }
        public Nullable<int> dist_niveis { get; set; }
        public Nullable<int> qtde_niveis_min { get; set; }
        public Nullable<int> qtde_niveis_max { get; set; }
        public Nullable<int> idcorte { get; set; }
        public string Var_alt { get; set; }
        public string Var_Compr { get; set; }
        public string Var_Prof { get; set; }
        public string qpn_desc { get; set; }
        public Nullable<int> qpn_valor { get; set; }
        public string tipo_corte { get; set; }
        public int idGondCorteCjtos { get; set; }
    }
}
