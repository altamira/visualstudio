using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_rel_prof_base
    {
        public Nullable<int> profundidade { get; set; }
        public Nullable<int> profundidade_base { get; set; }
        public string perfil { get; set; }
        public string nome_conjunto { get; set; }
        public int IdGondRelProfBase { get; set; }
    }
}
