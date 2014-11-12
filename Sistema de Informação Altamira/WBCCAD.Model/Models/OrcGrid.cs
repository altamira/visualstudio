using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcGrid
    {
        public string numeroOrcamento { get; set; }
        public string acessorio { get; set; }
        public Nullable<decimal> altura { get; set; }
        public string codigo { get; set; }
        public Nullable<decimal> comprimento { get; set; }
        public string conjunto { get; set; }
        public Nullable<int> controle { get; set; }
        public string cor { get; set; }
        public string corte { get; set; }
        public bool dep_alt { get; set; }
        public bool dep_compr { get; set; }
        public bool dep_prof { get; set; }
        public string departamento { get; set; }
        public string descritivo { get; set; }
        public bool flag_imprimir { get; set; }
        public string grupo_descricao { get; set; }
        public string id_cad { get; set; }
        public Nullable<int> IDCJTO { get; set; }
        public Nullable<int> item { get; set; }
        public string lista { get; set; }
        public Nullable<int> MATERIALEXTRA { get; set; }
        public string n_grupo { get; set; }
        public string n_subgrupo { get; set; }
        public string onde_incluir { get; set; }
        public string ORCGRID_CODIGO_ORI { get; set; }
        public Nullable<int> ORCGRID_PRC_ALTURA { get; set; }
        public Nullable<int> ORCGRID_PRC_COMPRIMENTO { get; set; }
        public Nullable<int> ORCGRID_PRC_FORMULA { get; set; }
        public Nullable<int> ORCGRID_PRC_LARGURA { get; set; }
        public string orcgridbase { get; set; }
        public string orcgridcorpesquisa { get; set; }
        public Nullable<decimal> OrcGridPeso { get; set; }
        public Nullable<decimal> OrcGridPrecoLista { get; set; }
        public string OrcGridProdutoImagem { get; set; }
        public string OrcGridTipoProduto { get; set; }
        public Nullable<int> ori_alt { get; set; }
        public Nullable<int> ori_compr { get; set; }
        public Nullable<int> ori_prof { get; set; }
        public string posicao_modulo { get; set; }
        public Nullable<decimal> profundidade { get; set; }
        public Nullable<double> qtde { get; set; }
        public string setor { get; set; }
        public string total { get; set; }
        public string utilizacao { get; set; }
        public Nullable<decimal> valor { get; set; }
        public Nullable<decimal> valor_unitario { get; set; }
        public string varusr { get; set; }
        public string vizatras { get; set; }
        public string vizfinal { get; set; }
        public string vizinicial { get; set; }
        public int orcgrid_counter { get; set; }
        public Nullable<decimal> orcgrid_kcal { get; set; }
        public string controleCad { get; set; }
        public Nullable<double> quantidadeOriginal { get; set; }
    }
}
