using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_crtgab
    {
        public string codigo { get; set; }
        public string linha { get; set; }
        public string tipo { get; set; }
        public Nullable<int> profundidade { get; set; }
        public Nullable<int> kcal { get; set; }
        public Nullable<int> potencia { get; set; }
        public string resfriamento { get; set; }
        public string grp_cor { get; set; }
        public string inclinacao { get; set; }
        public string inclusao_usuario { get; set; }
        public Nullable<int> inclusao_data { get; set; }
        public Nullable<int> inclusao_horario { get; set; }
        public string alteracao_usuario { get; set; }
        public Nullable<int> alteracao_data { get; set; }
        public Nullable<int> alteracao_horario { get; set; }
        public string prefixo_desenho { get; set; }
        public Nullable<int> altura_util { get; set; }
        public string situacao { get; set; }
        public Nullable<bool> esconder_orcamento { get; set; }
        public Nullable<bool> p_tensao { get; set; }
        public Nullable<bool> p_frequencia { get; set; }
        public Nullable<bool> p_condensacao { get; set; }
        public bool p_par4 { get; set; }
        public bool p_par5 { get; set; }
        public Nullable<int> altura { get; set; }
        public Nullable<int> alt_min_incl { get; set; }
        public Nullable<int> mult_modulacao { get; set; }
        public Nullable<int> alt_max_incl { get; set; }
        public Nullable<int> vlr_estr_int { get; set; }
        public string grupo_degelo { get; set; }
        public Nullable<int> numero_modulos_eqv_mec { get; set; }
        public Nullable<int> numero_modulos_eqv_eletr { get; set; }
        public Nullable<double> temperatura_trabalho { get; set; }
        public Nullable<double> temperatura_trabalho2 { get; set; }
        public string dia_liquidos { get; set; }
        public string dia_succao { get; set; }
        public Nullable<bool> possui_espelho { get; set; }
        public string prefixo_sgrupo { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public Nullable<bool> t_chave { get; set; }
        public Nullable<bool> t_cor { get; set; }
        public Nullable<bool> fechamento_duplo { get; set; }
        public string gab_int_temperatura { get; set; }
        public Nullable<int> quant_fc { get; set; }
        public int idGabCrtgab { get; set; }
    }
}
