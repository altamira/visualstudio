using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_acsg
    {
        public string acessorio { get; set; }
        public Nullable<int> flag_obrigatorio { get; set; }
        public string inmgab_codigo { get; set; }
        public string grp_cor { get; set; }
        public Nullable<double> pad_qtde_minima { get; set; }
        public Nullable<double> pad_qtde_maxima { get; set; }
        public Nullable<int> pad_opcional { get; set; }
        public Nullable<int> pad_dependencia { get; set; }
        public Nullable<double> pad_qtde_default { get; set; }
        public Nullable<int> pad_altura_util { get; set; }
        public Nullable<int> pad_potencia { get; set; }
        public Nullable<bool> pad_visivel { get; set; }
        public Nullable<int> pad_prioridade { get; set; }
        public Nullable<bool> pad_esconder_orcamento { get; set; }
        public Nullable<bool> p_tensao { get; set; }
        public Nullable<bool> p_frequencia { get; set; }
        public Nullable<bool> p_condensacao { get; set; }
        public Nullable<bool> p_par4 { get; set; }
        public Nullable<bool> p_par5 { get; set; }
        public string desenho { get; set; }
        public string codigo { get; set; }
        public Nullable<double> potencia { get; set; }
        public Nullable<int> qpn_valor_min { get; set; }
        public Nullable<int> qpn_valor_max { get; set; }
        public Nullable<int> qpn_valor_default { get; set; }
        public Nullable<bool> t_chave { get; set; }
        public Nullable<bool> t_cor { get; set; }
        public string SIGLACHB { get; set; }
        public Nullable<bool> t_corte { get; set; }
        public Nullable<bool> p_gas { get; set; }
        public Nullable<bool> nao_mostrar_p_configurar { get; set; }
        public Nullable<bool> possui_dep_arraste { get; set; }
        public Nullable<bool> def_qtde_p_arraste_de_outro { get; set; }
        public string mensagem_ao_inserir { get; set; }
        public int idGabAcsg { get; set; }
    }
}
