using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_prof_rel_prof_sup
    {
        public Nullable<int> profundidade { get; set; }
        public Nullable<int> profundidade_superior { get; set; }
        public Nullable<int> profundidade_superior_real { get; set; }
        public string perfil { get; set; }
        public int IdGondProfRelProfSup { get; set; }
    }
}
