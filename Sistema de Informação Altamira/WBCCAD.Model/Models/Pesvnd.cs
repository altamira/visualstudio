using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Pesvnd
    {
        public int pesvnd_codigo { get; set; }
        public bool pesvnd_comis_flag { get; set; }
        public string pesvnd_comis_tipo { get; set; }
        public Nullable<double> pesvnd_comis_percentual { get; set; }
        public string pesvnd_tipo { get; set; }
        public bool pesvnd_desabilitado { get; set; }
        public string PESVND_CARGO { get; set; }
        public string PESVND_IMAGEM { get; set; }
        public int idPesvnd { get; set; }
    }
}
