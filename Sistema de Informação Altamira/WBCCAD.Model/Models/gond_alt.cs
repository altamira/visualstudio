using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_alt
    {
        public int indice { get; set; }
        public Nullable<int> Altura { get; set; }
        public string altura_real { get; set; }
        public bool vale_para_edicao { get; set; }
    }
}
