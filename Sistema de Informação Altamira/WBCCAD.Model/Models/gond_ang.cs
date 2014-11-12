using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_ang
    {
        public string angulo { get; set; }
        public Nullable<int> valor { get; set; }
        public Nullable<bool> dep_comprimento { get; set; }
        public int idGondAng { get; set; }
        public string angulo_oposto { get; set; }
        public Nullable<double> comprimento_lado { get; set; }
        public Nullable<double> valor_angulo { get; set; }
    }
}
