using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class conf_empresa
    {
        public string Empresa { get; set; }
        public string CGC { get; set; }
        public string IE { get; set; }
        public string ENDERECO { get; set; }
        public string BAIRRO { get; set; }
        public string CIDADE { get; set; }
        public string CEP { get; set; }
        public string ESTADO { get; set; }
        public string CAMINHO_BASE { get; set; }
        public string CAMINHO_FIGURA { get; set; }
        public bool texto_bloco { get; set; }
        public Nullable<double> altura_texto { get; set; }
        public string bloco_legenda { get; set; }
        public Nullable<double> af_horizontal { get; set; }
        public Nullable<double> af_vertical { get; set; }
        public string caminho_alt_figura { get; set; }
        public string fone { get; set; }
        public string fax { get; set; }
        public string home { get; set; }
        public string texto_resumo { get; set; }
        public bool viz_ver { get; set; }
        public Nullable<double> precisao { get; set; }
        public string End_completo { get; set; }
        public string DBFClientes { get; set; }
        public string TabsClientes { get; set; }
        public string DBFPrecos { get; set; }
        public string TabsPrecos { get; set; }
        public string TipoClientes { get; set; }
        public string TipoPrecos { get; set; }
        public Nullable<int> trata_rel { get; set; }
        public Nullable<int> numeracao_1 { get; set; }
        public Nullable<int> numeracao_2 { get; set; }
        public string tipoVendedor { get; set; }
        public string DbfVendedor { get; set; }
        public string TabsVendedor { get; set; }
        public string arquivo_mat { get; set; }
        public bool set_acess { get; set; }
        public bool ref_externa { get; set; }
        public Nullable<double> fator_conv { get; set; }
        public string imagem_cli { get; set; }
        public bool ajust_imagem { get; set; }
        public Nullable<double> fator_desc { get; set; }
        public string compl_esp { get; set; }
        public string Validade { get; set; }
        public string Prazo_entrega { get; set; }
        public string Posto { get; set; }
        public bool OrdenCad { get; set; }
        public bool ValFamilia { get; set; }
        public string IR { get; set; }
        public string OndeVerStatus { get; set; }
        public bool ValidStatus { get; set; }
        public bool BloqMaior { get; set; }
        public bool PermValZero { get; set; }
        public Nullable<short> TipoRevisao { get; set; }
        public string TipoFrete { get; set; }
        public bool Def_pessoa { get; set; }
        public bool Acessar_ev { get; set; }
        public bool Perm_impress { get; set; }
        public bool Perm_Gravar { get; set; }
        public bool Viz_Proj_Acess { get; set; }
        public bool foco_usua { get; set; }
        public string Caminho_nOrca { get; set; }
        public string Lista_de_Precos { get; set; }
        public string LogoTipo { get; set; }
        public string EMAIL2 { get; set; }
        public int idConfEmpresa { get; set; }
    }
}
