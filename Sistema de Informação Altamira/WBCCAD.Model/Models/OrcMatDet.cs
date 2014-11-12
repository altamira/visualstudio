using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcMatDet
    {
        public int idOrcMatDet { get; set; }
        public Nullable<int> idGrupo { get; set; }
        public string idSubGrupo { get; set; }
        public string codigoProduto { get; set; }
        public string codigoProdutoPai { get; set; }
        public string descricao { get; set; }
        public string cor { get; set; }
        public string corPreco { get; set; }
        public Nullable<double> quantidade { get; set; }
        public Nullable<decimal> precoLista { get; set; }
        public Nullable<decimal> preco1 { get; set; }
        public Nullable<decimal> preco2 { get; set; }
        public Nullable<decimal> preco3 { get; set; }
        public Nullable<decimal> preco4 { get; set; }
        public Nullable<decimal> preco5 { get; set; }
        public Nullable<decimal> precoSemDesconto { get; set; }
        public string unidade { get; set; }
        public Nullable<double> altura { get; set; }
        public Nullable<double> comprimento { get; set; }
        public Nullable<double> largura { get; set; }
        public Nullable<double> peso { get; set; }
        public Nullable<double> qtdeM2 { get; set; }
        public string situacaoProduto { get; set; }
        public string baseProduto { get; set; }
        public Nullable<int> formulaPreco { get; set; }
        public Nullable<double> divisorPreco { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
