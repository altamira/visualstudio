using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class FormulaCalculo
    {
        public int idFormula { get; set; }
        public Nullable<int> idListaFatorCalculo { get; set; }
        public string DescricaoFormula { get; set; }
        public string Formula { get; set; }
        public string FormulaDetalhe { get; set; }
        public Nullable<int> ReferentePreco { get; set; }
    }
}
