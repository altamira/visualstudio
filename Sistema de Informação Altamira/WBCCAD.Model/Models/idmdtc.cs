using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class idmdtc
    {
        public string idioma { get; set; }
        public string dtc_codigo { get; set; }
        public string dtc_bmp { get; set; }
        public string dtc_linha { get; set; }
        public string dtc_inicial { get; set; }
        public Nullable<int> dtc_qtde_linhas { get; set; }
        public int idIdmDtc { get; set; }
    }
}
