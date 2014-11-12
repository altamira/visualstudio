using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_acess
    {
        public string descricao { get; set; }
        public string grupo_acab { get; set; }
        public string qtde_p_nivel { get; set; }
        public string inc_no_mod { get; set; }
        public string alt_conceito { get; set; }
        public Nullable<int> alt_valor { get; set; }
        public string compr_conceito { get; set; }
        public Nullable<int> compr_valor { get; set; }
        public Nullable<int> desenhar { get; set; }
        public Nullable<int> dist_compr { get; set; }
        public Nullable<int> dist_fundo { get; set; }
        public Nullable<int> qtde_p_nivel_valor { get; set; }
        public string TEXTO_CORTE { get; set; }
        public Nullable<bool> CODIGO_DEPENDE_COR { get; set; }
        public Nullable<bool> Nao_montar_chave_altura { get; set; }
        public Nullable<bool> Nao_montar_chave_profundidade { get; set; }
        public Nullable<bool> Nao_montar_chave_comprimento { get; set; }
        public Nullable<bool> nao_utilizar_compr_parametro { get; set; }
        public string qtde_p_nivel_formula { get; set; }
        public Nullable<bool> utilizar_carga_total { get; set; }
        public Nullable<bool> agrupar_acessorio { get; set; }
        public int idGondAcess { get; set; }
    }
}
