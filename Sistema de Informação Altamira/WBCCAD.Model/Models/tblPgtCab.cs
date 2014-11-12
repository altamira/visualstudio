using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tblPgtCab
    {
        public string descricao { get; set; }
        public Nullable<double> Fator { get; set; }
        public string codigo { get; set; }
        public string PGTCAB_CANAL_VENDA { get; set; }
        public Nullable<decimal> PGTCAB_VALOR_MINIMO { get; set; }
        public Nullable<decimal> PGTCAB_VALOR_MAXIMO { get; set; }
        public string PGTCAB_INTEGRACAO { get; set; }
        public Nullable<int> PGTCAB_PARCELAS { get; set; }
        public Nullable<decimal> PGTCAB_TX_FINANCEIRA { get; set; }
        public Nullable<bool> PGTCAB_FLAG_ESPECIAL { get; set; }
        public Nullable<decimal> PGTCAB_PRIMEIRA { get; set; }
        public int id { get; set; }
        public string condicaoPagamento { get; set; }
    }
}
