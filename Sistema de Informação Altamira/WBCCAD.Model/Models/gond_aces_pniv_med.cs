using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_aces_pniv_med
    {
        public string descricao { get; set; }
        public string aces_med_med_tipo { get; set; }
        public Nullable<int> aces_med_med_med { get; set; }
        public Nullable<int> aces_qpn_valor { get; set; }
        public int idGondAcesPnivMed { get; set; }
    }
}
