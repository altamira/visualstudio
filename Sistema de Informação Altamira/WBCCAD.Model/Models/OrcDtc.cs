using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcDtc
    {
        public string numeroOrcamento { get; set; }
        public Nullable<int> ORCDTCGRUPO { get; set; }
        public string ORCDTCSUBGRUPO { get; set; }
        public string ORCDTCCORTE { get; set; }
        public Nullable<int> ORCDTCID { get; set; }
        public string ORCDTCDTC { get; set; }
        public int idOrcDtc { get; set; }
        public string orcdtcids { get; set; }
        public string orcdtcitem { get; set; }
    }
}
