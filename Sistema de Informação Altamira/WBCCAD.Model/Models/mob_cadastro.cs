using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mob_cadastro
    {
        public string descricao { get; set; }
        public string cod_direito { get; set; }
        public string cod_esquerdo { get; set; }
        public string desenho { get; set; }
        public Nullable<int> comp_padrao { get; set; }
        public Nullable<int> comp_min { get; set; }
        public Nullable<int> comp_max { get; set; }
        public Nullable<int> prof_padrao { get; set; }
        public Nullable<int> prof_min { get; set; }
        public Nullable<int> prof_max { get; set; }
        public Nullable<int> alt_padrao { get; set; }
        public Nullable<int> alt_min { get; set; }
        public Nullable<int> alt_max { get; set; }
        public Nullable<int> alt_solo { get; set; }
        public string complemento { get; set; }
        public Nullable<bool> visivel { get; set; }
        public string bandeira { get; set; }
        public string familia { get; set; }
        public string corte { get; set; }
        public string grupo_cor { get; set; }
        public string nome_eqpto { get; set; }
        public string opcao { get; set; }
        public Nullable<int> consumo_eletrico { get; set; }
        public string consumo_tipo { get; set; }
        public string subgrupo { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public string tipo_cobrar { get; set; }
        public string codigo_montavel { get; set; }
        public string desenho_montavel { get; set; }
        public string grupo_caracteristica { get; set; }
        public string texto_p_corte { get; set; }
        public string corte_montavel { get; set; }
        public Nullable<double> parte_reta { get; set; }
        public Nullable<double> angulo { get; set; }
        public string grupo_restricao { get; set; }
        public Nullable<int> prioridade { get; set; }
        public string mensagem_ao_inserir { get; set; }
        public int idMobCadastro { get; set; }
    }
}
