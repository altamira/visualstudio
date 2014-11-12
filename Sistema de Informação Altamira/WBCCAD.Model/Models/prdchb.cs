using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prdchb
    {
        public string Produto { get; set; }
        public string Chave_busca_montada { get; set; }
        public string Chave_busca { get; set; }
        public string Dimensao_1 { get; set; }
        public string Dimensao_2 { get; set; }
        public string Dimensao_3 { get; set; }
        public string Dimensao_4 { get; set; }
        public Nullable<bool> Esconder_orcamento { get; set; }
        public Nullable<double> multiplo { get; set; }
        public Nullable<bool> dividir_multiplo { get; set; }
        public Nullable<decimal> multiploVizinho { get; set; }
        public int idPrdChb { get; set; }
    }
}
