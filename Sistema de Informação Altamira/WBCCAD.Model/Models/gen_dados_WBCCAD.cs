using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gen_dados_WBCCAD
    {
        public bool Nao_mostrar_compr_especial_gond { get; set; }
        public bool Nao_incluir_fechamento_interno { get; set; }
        public bool Nao_incluir_plaquetas { get; set; }
        public bool Nao_cab_leg_tubula { get; set; }
        public Nullable<double> altura_acima_forcador { get; set; }
        public bool utilizar_cabos_eletrica { get; set; }
        public string nomenclatura_maquinas_uc { get; set; }
        public Nullable<double> acresc_kcal_uc { get; set; }
        public Nullable<double> Valor_padrao_subida_maquina { get; set; }
        public bool nao_inc_rel_comprimentos_tubula { get; set; }
        public Nullable<int> Altura_canaleta_tubula { get; set; }
        public Nullable<int> altura_minima_incluir_subida { get; set; }
        public bool inverter_texto_diametros_legenda { get; set; }
    }
}
