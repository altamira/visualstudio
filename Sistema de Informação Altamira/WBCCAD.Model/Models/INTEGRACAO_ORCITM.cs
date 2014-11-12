using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class INTEGRACAO_ORCITM
    {
        public string ORCNUM { get; set; }
        public Nullable<int> GRPCOD { get; set; }
        public Nullable<int> SUBGRPCOD { get; set; }
        public Nullable<int> ORCITM { get; set; }
        public string ORCPRDCOD { get; set; }
        public Nullable<decimal> ORCPRDQTD { get; set; }
        public string ORCTXT { get; set; }
        public Nullable<decimal> ORCVAL { get; set; }
        public Nullable<decimal> ORCIPI { get; set; }
        public Nullable<decimal> ORCICM { get; set; }
        public int idIntegracao_OrcItm { get; set; }
    }
}
