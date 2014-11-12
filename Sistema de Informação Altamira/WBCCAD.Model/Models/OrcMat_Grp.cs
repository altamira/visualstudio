using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcMat_Grp
    {
        public int idOrcMatGrp { get; set; }
        public string orcmat_grp_codigo { get; set; }
        public string orcmat_grp_cor { get; set; }
        public Nullable<int> orcmat_grp_grupo { get; set; }
        public Nullable<double> orcmat_grp_qtde { get; set; }
        public string orcmat_grp_subgrupo { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
