using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcVarUsr
    {
        public int idOrcVarUsr { get; set; }
        public string numeroOrcamento { get; set; }
        public string varusrcodigo { get; set; }
        public string varusrvalor { get; set; }
        public bool RECALCULAR { get; set; }
    }
}
