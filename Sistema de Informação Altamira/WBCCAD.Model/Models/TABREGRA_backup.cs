using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class TABREGRA_backup
    {
        public string TipoVenda { get; set; }
        public string GrupoImpostos { get; set; }
        public Nullable<int> GrupoProduto { get; set; }
        public Nullable<decimal> IcmsFator { get; set; }
        public Nullable<decimal> IcmsRedutor { get; set; }
        public Nullable<decimal> IpiFator { get; set; }
        public string Natureza { get; set; }
        public Nullable<decimal> PISCOFINSFATOR { get; set; }
        public Nullable<bool> VERIFICAR { get; set; }
        public Nullable<decimal> PISFATOR { get; set; }
        public Nullable<decimal> COFINSFATOR { get; set; }
        public string TABREGRA_NODESCRITIVO { get; set; }
        public Nullable<decimal> ROYALTIES_CALCULO { get; set; }
        public Nullable<decimal> CUSTO_CALCULO { get; set; }
        public Nullable<decimal> REPASSE_CALCULO { get; set; }
        public Nullable<decimal> FRETE_CALCULO { get; set; }
        public Nullable<decimal> INDICE_COMPRA { get; set; }
        public Nullable<decimal> INDICE_FATURAMENTO { get; set; }
        public Nullable<decimal> IPI_NAO_INCLUSO { get; set; }
        public int idTABREGRA { get; set; }
    }
}
