using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_prof
    {
        public Nullable<int> Profundidade { get; set; }
        public Nullable<int> profundidade_real { get; set; }
        public Nullable<int> profundidade_real_curva { get; set; }
        public Nullable<bool> vale_para_edicao { get; set; }
        public int idGondProf { get; set; }
    }
}
