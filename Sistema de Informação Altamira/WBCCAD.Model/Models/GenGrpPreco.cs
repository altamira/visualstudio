using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class GenGrpPreco
    {
        public string GenGrpPrecoCodigo { get; set; }
        public Nullable<double> GenGrpPrecoFator { get; set; }
        public Nullable<decimal> GENGRPPRECOMULT { get; set; }
        public Nullable<decimal> GENGRPPRECOMULT2 { get; set; }
        public Nullable<decimal> GENGRPPRECOMULT3 { get; set; }
        public int idGenGrpPreco { get; set; }
    }
}
