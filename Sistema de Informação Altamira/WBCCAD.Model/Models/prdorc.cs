using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prdorc
    {
        public int indice { get; set; }
        public string Produto { get; set; }
        public string Descricao { get; set; }
        public string Unidade { get; set; }
        public Nullable<double> Peso { get; set; }
        public string Familia { get; set; }
        public string Cor_padrao { get; set; }
        public string Situacao { get; set; }
        public Nullable<double> Altura { get; set; }
        public Nullable<int> Comprimento { get; set; }
        public Nullable<int> Largura { get; set; }
        public string PrdOrcImagem { get; set; }
        public Nullable<double> Preco { get; set; }
        public string PRDORCVARIAVEIS { get; set; }
        public Nullable<int> IMPORTARESTRUTURA { get; set; }
        public string ORIGEM { get; set; }
        public Nullable<bool> TRAVAR_REPRESENTANTE { get; set; }
        public Nullable<int> PRDORCCHK { get; set; }
        public Nullable<bool> ITEMFATURADO { get; set; }
        public Nullable<System.DateTime> ATUALIZADOEM { get; set; }
        public Nullable<System.DateTime> IMPORTADOEM { get; set; }
        public string PRDORC_FORNECEDOR { get; set; }
        public string PRDORC_GRUPOCORESADC { get; set; }
        public string PRDORC_GRUPOCOR { get; set; }
        public Nullable<int> PRDORC_PRC_FORMULA { get; set; }
        public Nullable<int> PRDORC_PRC_COMPRIMENTO { get; set; }
        public Nullable<int> PRDORC_PRC_ALTURA { get; set; }
        public Nullable<int> PRDORC_PRC_LARGURA { get; set; }
        public string PRDDSCORC { get; set; }
        public string PRDCRTADC { get; set; }
        public Nullable<int> PRDORC_PRIORIDADE { get; set; }
        public Nullable<double> PRDORC_PESO_FIX { get; set; }
        public Nullable<double> PRDORC_PESO_CMP { get; set; }
        public Nullable<double> PRDORC_PESO_ALT { get; set; }
        public Nullable<double> PRDORC_PESO_PRF { get; set; }
        public Nullable<bool> PRDORC_EXP_FLAG_CMP { get; set; }
        public Nullable<bool> PRDORC_EXP_FLAG_ALT { get; set; }
        public Nullable<bool> PRDORC_EXP_FLAG_LRG { get; set; }
        public Nullable<bool> prdorc_semcentavos { get; set; }
        public string codigoIntegracao { get; set; }
    }
}
