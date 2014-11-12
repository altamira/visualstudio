using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_cab
    {
        public string descricao { get; set; }
        public string grupo { get; set; }
        public string codigo_produto { get; set; }
        public string desenho { get; set; }
        public Nullable<double> largura { get; set; }
        public bool esconder_orcamento { get; set; }
        public Nullable<int> sequencia_para_edicao { get; set; }
        public bool e_intermediaria { get; set; }
    }
}
