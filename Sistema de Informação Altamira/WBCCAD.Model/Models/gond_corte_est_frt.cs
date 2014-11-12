using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_corte_est_frt
    {
        public Nullable<int> idcorte { get; set; }
        public string est_frontal { get; set; }
        public Nullable<int> id_corte_est_frontal { get; set; }
        public string desenho_planta { get; set; }
        public Nullable<int> pos_insercao { get; set; }
        public int idGondCorteEstFrt { get; set; }
    }
}
