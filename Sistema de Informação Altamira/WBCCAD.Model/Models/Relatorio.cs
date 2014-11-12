using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Relatorio
    {
        public int idRelatorio { get; set; }
        public string Relatorio1 { get; set; }
        public string RelatorioPai { get; set; }
        public string Expressao { get; set; }
        public string Observacoes { get; set; }
        public bool Ativo { get; set; }
        public bool Padrao { get; set; }
    }
}
