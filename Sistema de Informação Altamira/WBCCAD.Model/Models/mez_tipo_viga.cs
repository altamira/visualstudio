using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mez_tipo_viga
    {
        public string nome { get; set; }
        public Nullable<int> comprimento { get; set; }
        public Nullable<int> largura { get; set; }
        public Nullable<int> altura { get; set; }
        public Nullable<int> qtde_max { get; set; }
        public Nullable<int> qtde_min { get; set; }
        public string tipo { get; set; }
        public string estilo { get; set; }
        public string gp_acab { get; set; }
        public bool especial { get; set; }
        public string sigla_ref_viga { get; set; }
        public string desenho { get; set; }
        public Nullable<double> wx { get; set; }
        public Nullable<double> ix { get; set; }
    }
}
