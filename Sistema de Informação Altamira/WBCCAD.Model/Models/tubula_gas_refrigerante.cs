using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tubula_gas_refrigerante
    {
        public string descricao_gas { get; set; }
        public bool e_padrao { get; set; }
        public Nullable<double> fator_correcao { get; set; }
    }
}
