using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class arm_escada_tipo_piso
    {
        public string descricao { get; set; }
        public bool padrao { get; set; }
        public Nullable<double> largura_degrau_fixa_em { get; set; }
    }
}
