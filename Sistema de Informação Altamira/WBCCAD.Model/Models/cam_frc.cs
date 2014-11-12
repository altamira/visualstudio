using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cam_frc
    {
        public string frc_descricao { get; set; }
        public string frc_codigo { get; set; }
        public string frc_desenho { get; set; }
        public Nullable<double> frc_kva { get; set; }
        public Nullable<double> frc_hp { get; set; }
        public Nullable<int> frc_comprimento { get; set; }
        public Nullable<int> frc_kcal { get; set; }
        public string frc_regime { get; set; }
        public string frc_fabricante { get; set; }
        public Nullable<int> frc_temperatura { get; set; }
        public string frc_grupo_degelo { get; set; }
        public string RTF_PADRAO { get; set; }
        public bool possui_resistencia { get; set; }
        public Nullable<double> carga_gas { get; set; }
        public Nullable<double> carga_oleo { get; set; }
        public bool frc_central { get; set; }
        public Nullable<int> multiplo_fixacao { get; set; }
        public string fase_resist { get; set; }
        public string fase_moto { get; set; }
        public Nullable<int> Alt_max_insercao { get; set; }
        public string Tipo_degelo { get; set; }
        public string dim_a { get; set; }
        public string dim_b { get; set; }
        public string dim_c { get; set; }
        public string dim_d { get; set; }
        public string dim_e { get; set; }
        public Nullable<double> frc_vazao { get; set; }
        public Nullable<double> frc_num_vent { get; set; }
    }
}
