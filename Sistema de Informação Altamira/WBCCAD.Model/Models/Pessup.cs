using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Pessup
    {
        public int pessup_codigo { get; set; }
        public bool pessup_comis_flag { get; set; }
        public string pessup_comis_tipo { get; set; }
        public Nullable<double> pessup_comis_percentual { get; set; }
        public bool pessup_desabilitado { get; set; }
        public string PESSUP_CARGO { get; set; }
        public int idPessup { get; set; }
    }
}
