using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_corte_est_sup
    {
        public Nullable<int> idcorte { get; set; }
        public string est_superior { get; set; }
        public Nullable<int> id_corte_est_superior { get; set; }
        public string desenho_planta { get; set; }
        public string pos_insercao { get; set; }
        public int idGondCorteEstSup { get; set; }
    }
}
