using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Orclst
    {
        public string orclst_numero { get; set; }
        public int orclst_status { get; set; }
        public Nullable<System.DateTime> orclst_cadastro { get; set; }
        public Nullable<System.DateTime> orclst_emissao { get; set; }
        public string orclst_contato { get; set; }
        public string orclst_loja { get; set; }
        public string orclst_municipio { get; set; }
        public string orclst_uf { get; set; }
        public Nullable<int> orclst_area { get; set; }
        public string orclst_planta { get; set; }
        public string orclst_corte { get; set; }
        public string orclst_orcamento { get; set; }
        public string orclst_nr_orc_vnd { get; set; }
        public string orclst_lista { get; set; }
        public string orclst_revisao { get; set; }
        public Nullable<double> orclst_total { get; set; }
        public string orclst_nova_reforma { get; set; }
        public string orclst_versao_dat { get; set; }
        public Nullable<int> orclst_cli_codigo { get; set; }
        public string orclst_cli_nome { get; set; }
        public string orclst_cli_cgc_cpf { get; set; }
        public string orclst_cli_end_especie { get; set; }
        public string orclst_cli_end_endereco { get; set; }
        public string orclst_cli_end_numero { get; set; }
        public string orclst_cli_end_bairro { get; set; }
        public string orclst_cli_end_cep { get; set; }
        public string orclst_cli_end_complemento { get; set; }
        public string orclst_cli_bmp { get; set; }
        public Nullable<System.DateTime> orclst_data_status { get; set; }
        public string orclst_revisao_orc { get; set; }
        public Nullable<int> orclst_temperatura { get; set; }
        public string orclst_motivo { get; set; }
        public string orclst_caminho_dwg { get; set; }
        public string orclst_pedido { get; set; }
        public Nullable<System.DateTime> orclst_pedido_data { get; set; }
        public string orclst_pedido_usuario { get; set; }
        public Nullable<System.DateTime> orclst_dataImportacao { get; set; }
        public Nullable<bool> orclst_email { get; set; }
        public Nullable<System.DateTime> orclst_data_email { get; set; }
        public string orclst_opcao_comissao { get; set; }
        public string OrcLst_EmUsoPor { get; set; }
        public string OrcLst_Computador { get; set; }
        public string BANDEIRA { get; set; }
        public Nullable<System.DateTime> ORCLSTDATAULTATUALIZACAO { get; set; }
        public Nullable<System.DateTime> ORCLSTDATAFATURAMENTO { get; set; }
        public Nullable<decimal> COMISSAO_FATOR { get; set; }
        public string ORCLST_REFERENCIA { get; set; }
        public Nullable<decimal> ORCLST_TOTAL1 { get; set; }
        public Nullable<decimal> ORCLST_TOTAL2 { get; set; }
        public Nullable<System.DateTime> ORCLSTDATAENTREGA { get; set; }
        public Nullable<System.DateTime> ORCLST_IMPORTACAO_LISTA { get; set; }
        public string ORCLST_GERENTE { get; set; }
        public string ORCLST_VENDEDOR { get; set; }
        public string ORCLST_PROJETISTA { get; set; }
        public string ORCLST_ORCAMENTISTA { get; set; }
        public int idOrcLst { get; set; }
        public string ORCLST_AGENTE { get; set; }
        public Nullable<decimal> ORCLST_TOTAL_LISTA { get; set; }
    }
}
