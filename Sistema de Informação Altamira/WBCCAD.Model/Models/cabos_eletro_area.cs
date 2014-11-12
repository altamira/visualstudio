using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cabos_eletro_area
    {
        public string tipo_eletro { get; set; }
        public Nullable<double> area_eletro { get; set; }
        public Nullable<double> area_maxima { get; set; }
        public bool aceitar_automatico { get; set; }
    }
}
