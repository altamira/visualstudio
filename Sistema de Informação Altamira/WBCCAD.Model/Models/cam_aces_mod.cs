using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cam_aces_mod
    {
        public string sigla { get; set; }
        public string sigla_aces { get; set; }
        public string acabamento { get; set; }
        public string formula_quantidade { get; set; }
        public Nullable<double> temperatura { get; set; }
        public Nullable<double> temperatura_minima { get; set; }
        public Nullable<double> temperatura_maxima { get; set; }
        public bool e_por_perimetro { get; set; }
        public string tipo_cad { get; set; }
    }
}
