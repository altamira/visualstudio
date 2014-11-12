using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class ItemRel
    {
        public int idItemRel { get; set; }
        public Nullable<int> ItemRel1 { get; set; }
        public string Item { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
