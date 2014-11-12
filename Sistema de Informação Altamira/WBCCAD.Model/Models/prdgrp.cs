using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prdgrp
    {
        public Nullable<int> Grupo { get; set; }
        public string Subgrupo { get; set; }
        public string Descricao { get; set; }
        public string Tipo_cad { get; set; }
        public Nullable<int> Proposta_ordem { get; set; }
        public Nullable<int> Proposta_grupo { get; set; }
        public string Proposta_descricao { get; set; }
        public string Proposta_imagem { get; set; }
        public string Proposta_texto_item { get; set; }
        public string Proposta_texto_base { get; set; }
        public string Agrupamento { get; set; }
        public Nullable<bool> Imprimir_sempre { get; set; }
        public Nullable<bool> Preco_cor { get; set; }
        public Nullable<System.DateTime> Data_preco_cor { get; set; }
        public string Tipo_produto { get; set; }
        public Nullable<bool> listar_dtc_produtos { get; set; }
        public string BancoUsar { get; set; }
        public string GrupoBusca { get; set; }
        public Nullable<bool> dividir_qtde_por_dois { get; set; }
        public string @base { get; set; }
        public Nullable<bool> suprimir_impressao_itens { get; set; }
        public string VARUSR { get; set; }
        public Nullable<int> RTFOPCAO { get; set; }
        public string RTFCAMPOSNORMAIS { get; set; }
        public string RTFCAMPOSESPECIAIS { get; set; }
        public string RTFCAMINHO { get; set; }
        public Nullable<int> GRUPO_CHECK { get; set; }
        public string PRDGRPIMPRESSAOOPCOES { get; set; }
        public Nullable<double> LIMITEVALOR { get; set; }
        public string PRDGRP_IMPRIMIR_PELO { get; set; }
        public Nullable<double> PRDGRP_QTDE_MOD { get; set; }
        public Nullable<double> PRDGRP_AGRUPAR_QTDE_MOD { get; set; }
        public Nullable<bool> PRDGRP_IMP_COMP_QTDE { get; set; }
        public string DSCFAT { get; set; }
        public string TABELA_CORTE { get; set; }
        public string TABELA_COMPR { get; set; }
        public string PRDGRP_OUTROS { get; set; }
        public Nullable<int> PRDGRPCMPMULT { get; set; }
        public Nullable<bool> imprimir_utilizacao { get; set; }
        public int idPrdGrp { get; set; }
        public string PRDGRP_OPCAO_MATEXTRA { get; set; }
        public string PRDGRPLINHA { get; set; }
    }
}
