using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Config_Geral
    {
        public string Dir_sistema { get; set; }
        public string Dir_padrao_dados { get; set; }
        public string Dir_resumo { get; set; }
        public Nullable<int> Prof_estr_gond { get; set; }
        public Nullable<int> Prof_estr_gond_ponta { get; set; }
        public string Sufixo_gond { get; set; }
        public string Sufixo_gond_estr { get; set; }
        public Nullable<int> Compr_ang_int { get; set; }
        public Nullable<float> Alt_txt_planta { get; set; }
        public Nullable<float> Alt_txt_corte { get; set; }
        public Nullable<int> Dist_hori_corte { get; set; }
        public Nullable<int> Dist_vert_corte { get; set; }
        public Nullable<int> Num_col_cortes { get; set; }
        public Nullable<int> Esc_des_formato { get; set; }
        public Nullable<int> Alt_text_formato { get; set; }
        public string Corte_gond_pad { get; set; }
        public Nullable<int> Alt_gond_pad { get; set; }
        public Nullable<int> Prof_gond_pad { get; set; }
        public string Fundo_gond_pad { get; set; }
        public string Frente_gond_pad { get; set; }
        public string Base_gond_pad { get; set; }
        public string Pad_lista_Gond { get; set; }
        public string Bloco_legenda { get; set; }
        public Nullable<int> Afast_vert { get; set; }
        public Nullable<int> Afast_Hori { get; set; }
        public string Pad_lista_exp { get; set; }
        public string Pad_lista_Camara { get; set; }
        public string Pad_lista_Maq { get; set; }
        public string Perfil_Config { get; set; }
        public Nullable<int> comp_min_gond { get; set; }
        public Nullable<int> comp_max_gond { get; set; }
        public string prefixo_orcamento { get; set; }
        public string dir_cartas { get; set; }
        public string dir_imagens { get; set; }
        public bool inc_pai { get; set; }
        public bool inc_teto { get; set; }
        public bool inc_piso { get; set; }
        public string dir_dwg { get; set; }
        public string Tipomed { get; set; }
        public bool autocad { get; set; }
        public string comp_min_gab { get; set; }
        public string comp_max_gab { get; set; }
        public string dwg_padrao { get; set; }
        public Nullable<int> t_salvar { get; set; }
        public Nullable<short> hab_prop { get; set; }
        public Nullable<short> hab_vis { get; set; }
        public string sufixo_gond_pta { get; set; }
        public string Corte_gond_pta_pad { get; set; }
        public string fundo_gond_pta_pad { get; set; }
        public string base_gond_pta_pad { get; set; }
        public string cfgPassword { get; set; }
        public string DIR_MOB_USUARIO { get; set; }
        public int IdConfigGeral { get; set; }
    }
}
