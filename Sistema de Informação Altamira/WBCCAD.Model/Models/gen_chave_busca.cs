using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gen_chave_busca
    {
        public int indice { get; set; }
        public string nome { get; set; }
        public string sigla { get; set; }
        public string descritivoTecnico { get; set; }
        public Nullable<bool> EsconderOrcamento { get; set; }
    }
}
