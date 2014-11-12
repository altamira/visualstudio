using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_tp_frt
    {
        public string Tipo_frente { get; set; }
        public Nullable<int> valor { get; set; }
        public Nullable<bool> dep_dimensoes { get; set; }
        public string frente_lado_oposto { get; set; }
        public string sufixo_tipo { get; set; }
        public Nullable<bool> incluir_estrutura { get; set; }
        public int idGondTpFrt { get; set; }
        public string prefixo_estrutura { get; set; }
    }
}
