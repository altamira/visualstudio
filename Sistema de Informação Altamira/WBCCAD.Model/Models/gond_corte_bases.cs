using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_corte_bases
    {
        public Nullable<int> idcorte { get; set; }
        public string @base { get; set; }
        public Nullable<int> id_corte_base { get; set; }
        public Nullable<int> altura_base { get; set; }
        public int idGondCorteBases { get; set; }
    }
}
