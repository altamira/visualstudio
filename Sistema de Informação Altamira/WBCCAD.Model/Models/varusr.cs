using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class varusr
    {
        public int idVarusr { get; set; }
        public string varusrcodigo { get; set; }
        public string varusrdescricao { get; set; }
        public Nullable<int> varusrtipo { get; set; }
        public string varusrgrupo { get; set; }
        public Nullable<decimal> VARUSRVALOR { get; set; }
        public string VARUSRPADRAO { get; set; }
        public string VarUsrLista { get; set; }
    }
}
