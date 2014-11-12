using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cam_prt
    {
        public string prt_descricao { get; set; }
        public string prt_codigo_esquerdo { get; set; }
        public string prt_codigo_direito { get; set; }
        public string prt_desenho { get; set; }
        public Nullable<int> prt_comprimento_pad { get; set; }
        public Nullable<int> prt_comprimento_min { get; set; }
        public Nullable<int> prt_comprimento_max { get; set; }
        public Nullable<int> prt_altura_pad { get; set; }
        public Nullable<int> prt_altura_min { get; set; }
        public Nullable<int> prt_altura_max { get; set; }
        public Nullable<double> mult_modulo { get; set; }
        public string prt_fabricante { get; set; }
        public string TEXTO_PLANTA { get; set; }
        public Nullable<int> ALTURA_SOLO { get; set; }
        public string SUFIXO_DESENHO { get; set; }
        public Nullable<double> potencia_degelo { get; set; }
        public Nullable<double> kcal_porta { get; set; }
        public string TIPO_CAD { get; set; }
        public string compl_desenho { get; set; }
        public string tipo_porta { get; set; }
        public Nullable<int> altura_minima_solo { get; set; }
        public bool inativo { get; set; }
    }
}
