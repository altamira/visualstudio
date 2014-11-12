using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class TiposAco
    {
        public int idTipoAcao { get; set; }
        public string TipoAcao { get; set; }
        public Nullable<int> Ordem { get; set; }
        public string Observacoes { get; set; }
    }
}
