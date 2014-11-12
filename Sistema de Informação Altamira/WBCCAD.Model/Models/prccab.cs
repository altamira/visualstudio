using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prccab
    {
        public string lista { get; set; }
        public string observacao { get; set; }
        public string lista_produto { get; set; }
        public string lista_fator { get; set; }
        public Nullable<System.DateTime> criacao { get; set; }
        public Nullable<System.DateTime> utilizacao_ini { get; set; }
        public Nullable<System.DateTime> utilizacao_fim { get; set; }
        public string cliente { get; set; }
        public Nullable<System.DateTime> importacao { get; set; }
        public string moeda { get; set; }
        public string PrcCabListaCor { get; set; }
        public string INTEGRACAO { get; set; }
        public string PRCVAL_CODIGO { get; set; }
        public int idPrccab { get; set; }
        public string lista_calculo { get; set; }
    }
}
