using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class INTEGRACAO_ORCIND
    {
        public string ORCNUM { get; set; }
        public string TIPINDCOD { get; set; }
        public Nullable<decimal> ORCVAL { get; set; }
        public int idIntegracao_OrcInd { get; set; }
    }
}
