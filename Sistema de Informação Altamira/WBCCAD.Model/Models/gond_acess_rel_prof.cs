using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_acess_rel_prof
    {
        public string descricao { get; set; }
        public string ang { get; set; }
        public string tipo_frente { get; set; }
        public Nullable<int> id_corte_frontal { get; set; }
        public string conceito { get; set; }
        public string ch_busca { get; set; }
        public Nullable<int> valor { get; set; }
        public string desenho_2d { get; set; }
        public string prefixo_2d { get; set; }
        public Nullable<int> med_alt_2d { get; set; }
        public Nullable<int> med_larg_2d { get; set; }
        public string var_larg_2d { get; set; }
        public string var_alt_2d { get; set; }
        public Nullable<int> afs_fundo_2d { get; set; }
        public Nullable<int> afs_inicio_2d { get; set; }
        public string desenho_3d { get; set; }
        public string prefixo_3d { get; set; }
        public Nullable<int> med_alt_3d { get; set; }
        public Nullable<int> med_larg_3d { get; set; }
        public Nullable<int> med_compr_3d { get; set; }
        public Nullable<int> afs_fundo_3d { get; set; }
        public Nullable<int> afs_inicio_3d { get; set; }
        public Nullable<bool> ativo { get; set; }
        public string Var_alt_3d { get; set; }
        public string Var_larg_3d { get; set; }
        public string Var_compr_3d { get; set; }
        public int idGondAcessRelProf { get; set; }
    }
}
