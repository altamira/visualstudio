using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class TstCab
    {
        public int TstCabCodigo { get; set; }
        public string TstCabDescricao { get; set; }
        public Nullable<bool> TstCabBloqueado { get; set; }
        public Nullable<System.DateTime> TstCabData { get; set; }
        public Nullable<double> TstCabValor { get; set; }
    }
}
