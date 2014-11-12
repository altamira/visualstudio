using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Secao
    {
        public int idSecao { get; set; }
        public string Secao1 { get; set; }
        public Nullable<int> Ordem { get; set; }
        public string Observacoes { get; set; }
        public Nullable<bool> Ativa { get; set; }
    }
}
