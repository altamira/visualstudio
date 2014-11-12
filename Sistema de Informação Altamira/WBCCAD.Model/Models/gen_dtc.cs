using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gen_dtc
    {
        public int indice { get; set; }
        public string dtc_codigo { get; set; }
        public string dtc_bmp { get; set; }
        public string dtc_linha { get; set; }
        public string dtc_inicial { get; set; }
        public Nullable<int> dtc_qtde_linhas { get; set; }
        public string dtcrtf { get; set; }
        public Nullable<int> GEN_DTC_ALT { get; set; }
        public Nullable<int> GEN_DTC_LRG { get; set; }
    }
}
