using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcVarCalculo
    {
        public int idOrcVarCalculo { get; set; }
        public string numeroOrcamento { get; set; }
        public string Chave { get; set; }
        public Nullable<decimal> Valor { get; set; }
        public string ChaveImpressao { get; set; }
        public Nullable<bool> DistribuirValor { get; set; }
        public Nullable<bool> Servico { get; set; }
    }
}
