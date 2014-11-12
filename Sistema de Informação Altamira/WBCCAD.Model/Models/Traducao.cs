using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Traducao
    {
        public int idTraducao { get; set; }
        public string PalavraChave { get; set; }
        public string Complemento { get; set; }
        public string TraducaoEN { get; set; }
        public string TraducaoES { get; set; }
        public string TraducaoPT { get; set; }
        public string TraducaoIT { get; set; }
    }
}
