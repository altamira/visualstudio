using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Peslog
    {
        public Nullable<int> peslog_codigo { get; set; }
        public int peslog_nr_seq { get; set; }
        public string peslog_tipo { get; set; }
        public Nullable<System.DateTime> peslog_data { get; set; }
        public string peslog_obs { get; set; }
        public string peslog_usuario { get; set; }
    }
}
