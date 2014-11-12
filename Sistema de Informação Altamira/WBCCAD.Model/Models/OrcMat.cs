using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcMat
    {
        public string numeroOrcamento { get; set; }
        public Nullable<decimal> COMISSAO_FATOR { get; set; }
        public Nullable<decimal> ENCARGOS_VALOR { get; set; }
        public Nullable<decimal> FreteValor { get; set; }
        public Nullable<decimal> IcmsBase { get; set; }
        public Nullable<decimal> IcmsFator { get; set; }
        public Nullable<decimal> IcmsRedutor { get; set; }
        public Nullable<decimal> IcmsValor { get; set; }
        public Nullable<decimal> IpiBase { get; set; }
        public Nullable<decimal> IpiFator { get; set; }
        public Nullable<decimal> IpiValor { get; set; }
        public Nullable<decimal> MontagemValor { get; set; }
        public string NATUREZA { get; set; }
        public string orcmat_codigo { get; set; }
        public string orcmat_codigo_pai { get; set; }
        public string orcmat_cor { get; set; }
        public string orcmat_descricao { get; set; }
        public string ORCMAT_FORNECEDOR { get; set; }
        public string ORCMAT_IDMDESCRICAO { get; set; }
        public string ORCMAT_IDMUNIDADE { get; set; }
        public Nullable<decimal> orcmat_peso { get; set; }
        public Nullable<int> ORCMAT_PRC_ALTURA { get; set; }
        public Nullable<int> ORCMAT_PRC_COMPRIMENTO { get; set; }
        public Nullable<int> ORCMAT_PRC_FORMULA { get; set; }
        public Nullable<bool> ORCMAT_SEMCENTAVOS { get; set; }
        public Nullable<int> ORCMAT_PRC_LARGURA { get; set; }
        public string ORCMAT_PRDUNIDADE { get; set; }
        public Nullable<decimal> orcmat_preco { get; set; }
        public Nullable<decimal> orcmat_preco_lista { get; set; }
        public Nullable<decimal> orcmat_preco_lista_sem { get; set; }
        public Nullable<decimal> ORCMAT_PRECO_TAB { get; set; }
        public Nullable<double> orcmat_qtde { get; set; }
        public Nullable<double> ORCMATALTURA { get; set; }
        public string orcmatbase { get; set; }
        public Nullable<double> ORCMATCOMPRIMENTO { get; set; }
        public string OrcMatCorPesquisa { get; set; }
        public Nullable<decimal> ORCMATDESCONTO { get; set; }
        public Nullable<int> OrcMatGrupo { get; set; }
        public Nullable<double> ORCMATLARGURA { get; set; }
        public string orcmatlista { get; set; }
        public string ORCMATSITUACAO { get; set; }
        public string OrcMatSubGrupo { get; set; }
        public Nullable<decimal> PISCOFINSFATOR { get; set; }
        public Nullable<decimal> PISCOFINSVALOR { get; set; }
        public Nullable<int> PRDORCCHK { get; set; }
        public Nullable<decimal> preco_fixo { get; set; }
        public Nullable<decimal> PISFATOR { get; set; }
        public Nullable<decimal> COFINSFATOR { get; set; }
        public Nullable<decimal> ROYALTIES_CALCULO { get; set; }
        public Nullable<decimal> CUSTO_CALCULO { get; set; }
        public Nullable<decimal> REPASSE_CALCULO { get; set; }
        public Nullable<decimal> FRETE_CALCULO { get; set; }
        public Nullable<decimal> INDICE_COMPRA { get; set; }
        public Nullable<decimal> INDICE_FATURAMENTO { get; set; }
        public Nullable<decimal> IPI_NAO_INCLUSO { get; set; }
        public int orcmat_counter { get; set; }
    }
}
