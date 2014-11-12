using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Mob_SubGrp
    {
        public string Nome_Eqpto { get; set; }
        public string SubGrupo { get; set; }
        public string Tipo_cad { get; set; }
        public Nullable<bool> esconder_projeto { get; set; }
        public Nullable<bool> tratar_como_caracteristica { get; set; }
        public int idMobSubGrp { get; set; }
    }
}
