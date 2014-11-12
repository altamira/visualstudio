using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_cabdet
    {
        public string descricao { get; set; }
        public string flag_e_d { get; set; }
        public string ligacao { get; set; }
        public Nullable<bool> e_intermediaria { get; set; }
        public int idGabCabdet { get; set; }
    }
}
