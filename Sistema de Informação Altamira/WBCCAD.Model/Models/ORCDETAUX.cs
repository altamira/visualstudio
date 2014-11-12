using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class ORCDETAUX
    {
        public Nullable<int> orcdet_grupo { get; set; }
        public string orcdet_subgrupo { get; set; }
        public string orcdet_corte { get; set; }
        public Nullable<int> orcdet_nr_seq { get; set; }
        public string orcdet_nr_seq_crt { get; set; }
        public string orcdet_codigo { get; set; }
        public string orcdet_cor { get; set; }
        public Nullable<decimal> orcdet_qtde { get; set; }
        public bool dep_alt { get; set; }
        public bool dep_compr { get; set; }
        public bool dep_prof { get; set; }
        public string DEPARTAMENTO { get; set; }
        public Nullable<int> IDCJTO { get; set; }
        public Nullable<int> MATERIALEXTRA { get; set; }
        public string orcdet_acessorio { get; set; }
        public string ORCDET_AGRUPAMENTO { get; set; }
        public Nullable<decimal> orcdet_Altura { get; set; }
        public string orcdet_chb { get; set; }
        public string ORCDET_CODIGO_ORI { get; set; }
        public Nullable<decimal> orcdet_Comprimento { get; set; }
        public string ORCDET_CORESADC { get; set; }
        public Nullable<decimal> orcdet_fator_ref { get; set; }
        public bool orcdet_flag_imprimir { get; set; }
        public bool orcdet_flag_suprimir { get; set; }
        public string orcdet_identificador { get; set; }
        public string orcdet_obs { get; set; }
        public string orcdet_onde_incluir { get; set; }
        public Nullable<decimal> orcdet_peso { get; set; }
        public Nullable<int> ORCDET_PRC_ALTURA { get; set; }
        public Nullable<int> ORCDET_PRC_COMPRIMENTO { get; set; }
        public Nullable<int> ORCDET_PRC_FORMULA { get; set; }
        public Nullable<int> ORCDET_PRC_LARGURA { get; set; }
        public Nullable<int> orcdet_prd_ref { get; set; }
        public Nullable<decimal> orcdet_preco_lista { get; set; }
        public Nullable<decimal> orcdet_Profundidade { get; set; }
        public Nullable<decimal> ORCDETBASALT { get; set; }
        public string orcdetbase { get; set; }
        public Nullable<decimal> ORCDETBASPRF1 { get; set; }
        public Nullable<decimal> ORCDETBASPRF2 { get; set; }
        public Nullable<decimal> ORCDETBASPRFEST { get; set; }
        public Nullable<int> ORCDETBASQTD { get; set; }
        public string orcdetcorpesquisa { get; set; }
        public Nullable<decimal> OrcDetPrecoLista { get; set; }
        public string OrcDetProdutoImagem { get; set; }
        public Nullable<int> ORCDETPROPOSTAGRUPO { get; set; }
        public string OrcDetTipoProduto { get; set; }
        public Nullable<int> ori_alt { get; set; }
        public Nullable<int> ori_compr { get; set; }
        public Nullable<int> ori_prof { get; set; }
        public string SETOR { get; set; }
        public string UTILIZACAO { get; set; }
        public string varusr { get; set; }
        public Nullable<int> ORCDETCMPMULTI { get; set; }
        public int ORCDET_COUNTER { get; set; }
        public bool ORCDET_EXP_FLAG_CMP { get; set; }
        public bool ORCDET_EXP_FLAG_ALT { get; set; }
        public bool ORCDET_EXP_FLAG_LRG { get; set; }
        public Nullable<decimal> ORCDET_KCAL { get; set; }
        public string controleCAD { get; set; }
        public string vizatras { get; set; }
        public Nullable<double> orcdet_area { get; set; }
        public string vizinicial { get; set; }
        public string vizfinal { get; set; }
        public Nullable<double> quantidadeOriginal { get; set; }
        public string orcdet_item { get; set; }
    }
}
