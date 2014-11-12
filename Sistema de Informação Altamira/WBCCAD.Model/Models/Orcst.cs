using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Orcst
    {
        public Nullable<int> st_codigo { get; set; }
        public string st_descricao { get; set; }
        public Nullable<bool> st_flag_ativo { get; set; }
        public int idOrcst { get; set; }
    }
}
