using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class arm_escada_acessorios
    {
        public string descricao { get; set; }
        public string codigo { get; set; }
        public string formula_dimensao { get; set; }
        public string formula_quantidade { get; set; }
        public string tipo_incluir { get; set; }
        public string formula_comprimento { get; set; }
        public string formula_altura { get; set; }
        public string formula_profundidade { get; set; }
        public string tipo_piso { get; set; }
        public string tipo_cad { get; set; }
        public Nullable<int> multiplo { get; set; }
        public Nullable<int> dimensao_maxima_sem_juncao { get; set; }
        public string codigo_juncao { get; set; }
        public Nullable<double> comprimento_maximo_aceitar { get; set; }
        public Nullable<double> comprimento_minimo_aceitar { get; set; }
        public Nullable<double> profundidade_padrao { get; set; }
        public Nullable<double> largura_maxima_aceitar { get; set; }
        public Nullable<double> largura_minima_aceitar { get; set; }
        public bool acess_guarda_corpo { get; set; }
        public string grupo_acab { get; set; }
    }
}
