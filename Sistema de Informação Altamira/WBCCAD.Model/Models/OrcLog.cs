using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcLog
    {
        public string numeroOrcamento { get; set; }
        public Nullable<System.DateTime> orclog_data { get; set; }
        public Nullable<System.DateTime> orclog_time { get; set; }
        public string orclog_usuario { get; set; }
        public int orclog_nr_seq { get; set; }
        public string orclog_linha { get; set; }
    }
}
