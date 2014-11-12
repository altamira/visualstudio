using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class INTEGRACAO_ORCPRDARV
    {
        public string ORCNUM { get; set; }
        public Nullable<int> GRPCOD { get; set; }
        public Nullable<int> SUBGRPCOD { get; set; }
        public Nullable<int> ORCITM { get; set; }
        public string PRDCOD { get; set; }
        public Nullable<int> ORCPRDARV_NIVEL { get; set; }
        public string CORCOD { get; set; }
        public string PRDDSC { get; set; }
        public Nullable<double> ORCQTD { get; set; }
        public Nullable<double> ORCTOT { get; set; }
        public Nullable<double> ORCPES { get; set; }
        public int idIntegracao_OrcPrdArv { get; set; }
        public Nullable<System.DateTime> orcprdarv_dth { get; set; }
    }
}
