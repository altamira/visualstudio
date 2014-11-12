using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_param_med_aces
    {
        public int identificacao { get; set; }
        public string acessorio { get; set; }
        public Nullable<int> medida { get; set; }
        public string codigo { get; set; }
        public Nullable<int> qtde_por_nivel_min { get; set; }
        public Nullable<int> qtde_por_nivel_max { get; set; }
        public Nullable<int> qtde_por_nivel_pad { get; set; }
        public Nullable<int> potencia { get; set; }
        public Nullable<int> sequencia_edicao { get; set; }
        public string tipo_med { get; set; }
        public string v_tensao { get; set; }
        public string v_frequencia { get; set; }
        public string v_condensacao { get; set; }
        public string v_par4 { get; set; }
        public string v_par5 { get; set; }
        public Nullable<int> potencia_orvalho { get; set; }
        public Nullable<int> potencia_iluminacao { get; set; }
    }
}
