using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcItm
    {
        public string numeroOrcamento { get; set; }
        public Nullable<decimal> orcitm_altura { get; set; }
        public Nullable<decimal> orcitm_comprimento { get; set; }
        public Nullable<bool> OrcItm_Desc_Destacado { get; set; }
        public Nullable<decimal> OrcItm_Desconto_Grupo { get; set; }
        public Nullable<decimal> OrcItm_Diferenca { get; set; }
        public string orcitm_dtc { get; set; }
        public Nullable<decimal> OrcItm_Encargos { get; set; }
        public Nullable<decimal> OrcItm_Frete { get; set; }
        public Nullable<int> orcitm_grupo { get; set; }
        public Nullable<decimal> OrcItm_IPI { get; set; }
        public Nullable<decimal> orcitm_largura { get; set; }
        public Nullable<decimal> OrcItm_Preco_Lista { get; set; }
        public Nullable<decimal> OrcItm_Preco_Lista_Sem { get; set; }
        public Nullable<double> orcitm_qtde { get; set; }
        public string ORCITM_REFERENCIA { get; set; }
        public string orcitm_subgrupo { get; set; }
        public Nullable<bool> orcitm_suprimir_itens { get; set; }
        public Nullable<int> ORCITM_TOTAL { get; set; }
        public Nullable<decimal> OrcItm_ValGrupoComDesc { get; set; }
        public Nullable<decimal> orcitm_valor_total { get; set; }
        public string proposta_descricao { get; set; }
        public Nullable<int> proposta_grupo { get; set; }
        public string proposta_imagem { get; set; }
        public Nullable<int> proposta_ordem { get; set; }
        public string proposta_texto_base { get; set; }
        public string proposta_texto_item { get; set; }
        public int idOrcItm { get; set; }
        public string orcitm_item { get; set; }
    }
}
