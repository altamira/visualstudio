using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class arm_escada_parametros
    {
        public Nullable<int> altura_degrau_minimo { get; set; }
        public Nullable<int> altura_degrau_maximo { get; set; }
        public Nullable<int> altura_degrau_padrao { get; set; }
        public Nullable<int> largura_degrau_minimo { get; set; }
        public Nullable<int> largura_degrau_maximo { get; set; }
        public Nullable<int> largura_degrau_padrao { get; set; }
        public Nullable<int> comprimento_degrau_maximo { get; set; }
        public Nullable<int> Altura_maxima_simples { get; set; }
        public Nullable<int> Altura_maxima_com_patamar { get; set; }
        public bool permitir_patamar { get; set; }
    }
}
