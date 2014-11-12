using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class GrpPreco
    {
        public int idGrpPreco { get; set; }
        public string GrpPreco_descricao { get; set; }
        public string GenGrpPrecoCodigo { get; set; }
        public string Produto { get; set; }
        public double GenGrpPrecoFator { get; set; }
    }
}
