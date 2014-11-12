using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class arm_piso_acessorios_GEN
    {
        public string Descricao { get; set; }
        public string codigo { get; set; }
        public string formula_quantidade { get; set; }
        public string tipo_incluir { get; set; }
        public string Tipo_apoio_incluir { get; set; }
        public string formula_dimensao { get; set; }
        public Nullable<double> multiplo { get; set; }
        public Nullable<double> dimensao_maxima_sem_juncao { get; set; }
        public string codigo_juncao { get; set; }
        public Nullable<double> dimensao_padrao { get; set; }
        public string descricao_cantoneira { get; set; }
        public bool para_piso_intermediario { get; set; }
        public bool tratar_como_piso { get; set; }
        public Nullable<double> comprimento_maximo_aceitar { get; set; }
        public Nullable<double> comprimento_minimo_aceitar { get; set; }
        public bool Aces_des_por_Pontos { get; set; }
        public string des_retang_ref { get; set; }
        public string cor_des_retang_ref { get; set; }
    }
}
