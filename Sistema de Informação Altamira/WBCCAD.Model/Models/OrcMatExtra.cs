using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcMatExtra
    {
        public int idOrcMatExtra { get; set; }
        public string codigoProduto { get; set; }
        public string corProduto { get; set; }
        public string grupo { get; set; }
        public string subgrupo { get; set; }
        public string corte { get; set; }
        public string id { get; set; }
        public string departamento { get; set; }
        public string setor { get; set; }
        public string utilizacao { get; set; }
        public Nullable<double> quantidade { get; set; }
        public Nullable<double> quantidadeUtilizada { get; set; }
        public string numeroOrcamento { get; set; }
        public string item { get; set; }
    }
}
