using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cfosecao
    {
        public string perfil { get; set; }
        public string secao { get; set; }
        public bool imprimir { get; set; }
        public Nullable<float> ordem_impressao { get; set; }
        public string texto_indice { get; set; }
    }
}
