using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_param_med_crt
    {
        public int identificacao { get; set; }
        public Nullable<int> medida { get; set; }
        public string codigo { get; set; }
        public Nullable<int> potencia { get; set; }
        public string Corte { get; set; }
        public Nullable<int> sequencia_edicao { get; set; }
        public string tipo_med { get; set; }
        public Nullable<double> medida_reta_corte { get; set; }
        public Nullable<double> medida_p_reta_corte { get; set; }
        public string v_tensao { get; set; }
        public string v_frequencia { get; set; }
        public string v_condensacao { get; set; }
        public string v_par4 { get; set; }
        public string v_par5 { get; set; }
        public Nullable<int> potencia_orvalho { get; set; }
        public Nullable<int> potencia_iluminacao { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public Nullable<double> potencia_2 { get; set; }
        public Nullable<double> potencia_resistencia_degelo_2 { get; set; }
        public Nullable<double> potencia_orvalho_2 { get; set; }
        public Nullable<double> potencia_iluminacao_2 { get; set; }
    }
}
