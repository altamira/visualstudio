using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class PRDFAM_GENGRPPRC
    {
        public string FAMILIA { get; set; }
        public string GenGrpPrecoCodigo { get; set; }
        public Nullable<decimal> FATOR { get; set; }
        public int idPrdfamGengrpprc { get; set; }
    }
}
