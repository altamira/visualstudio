using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class INTEGRACAO_ORCCAB
    {
        public string ORCNUM { get; set; }
        public Nullable<int> SITCOD { get; set; }
        public Nullable<System.DateTime> ORCALTDTH { get; set; }
        public Nullable<decimal> ORCVALVND { get; set; }
        public Nullable<decimal> ORCVALLST { get; set; }
        public Nullable<decimal> ORCVALINV { get; set; }
        public Nullable<decimal> ORCVALLUC { get; set; }
        public Nullable<decimal> ORCVALEXP { get; set; }
        public Nullable<decimal> ORCVALCOM { get; set; }
        public Nullable<decimal> ORCPERCOM { get; set; }
        public string REPCOD { get; set; }
        public Nullable<int> CLICOD { get; set; }
        public string CLINOM { get; set; }
        public Nullable<int> CLICONCOD { get; set; }
        public string CLICON { get; set; }
        public Nullable<decimal> ORCVALTRP { get; set; }
        public Nullable<decimal> ORCVALEMB { get; set; }
        public Nullable<decimal> ORCVALMON { get; set; }
        public string PGTCOD { get; set; }
        public string TIPMONCOD { get; set; }
        public Nullable<int> PRZENT { get; set; }
        public Nullable<decimal> ORCBAS1 { get; set; }
        public Nullable<decimal> ORCBAS2 { get; set; }
        public Nullable<decimal> ORCBAS3 { get; set; }
        public string ORCPGT { get; set; }
        public int idIntegracao_OrcCab { get; set; }
    }
}
