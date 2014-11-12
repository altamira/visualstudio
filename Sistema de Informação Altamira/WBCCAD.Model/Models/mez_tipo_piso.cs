using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mez_tipo_piso
    {
        public string Nome { get; set; }
        public string Tipo { get; set; }
        public string gp_acab { get; set; }
        public string larg { get; set; }
        public string comp { get; set; }
        public string cor_piso { get; set; }
        public string montar_chave { get; set; }
        public string dim_soma_ao_arremat { get; set; }
        public bool metal { get; set; }
    }
}
