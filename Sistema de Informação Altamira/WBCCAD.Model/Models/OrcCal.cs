using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcCal
    {
        public int idOrcCal { get; set; }
        public Nullable<decimal> orccal_fator { get; set; }
        public Nullable<int> orccal_grupo { get; set; }
        public Nullable<int> orccal_nr_vezes { get; set; }
        public string orccal_tipo_calculo { get; set; }
        public Nullable<decimal> orccal_valor { get; set; }
        public Nullable<decimal> ORCCALTOTALLISTA { get; set; }
        public Nullable<decimal> ORCCALTOTALVENDA { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
