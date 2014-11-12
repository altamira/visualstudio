using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_dados_corte
    {
        public string Nome_corte { get; set; }
        public string Tipo_corte { get; set; }
        public string lista { get; set; }
        public int idcorte { get; set; }
        public Nullable<double> altura_base { get; set; }
        public string desenho_planta { get; set; }
        public string posicao { get; set; }
        public Nullable<bool> corte_config { get; set; }
        public Nullable<double> ALturaMinima { get; set; }
        public Nullable<double> passo { get; set; }
        public Nullable<int> prof_estr { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public Nullable<double> sobra_modulo { get; set; }
        public string sufixo_estrutura { get; set; }
        public Nullable<bool> trat_base { get; set; }
        public Nullable<bool> alt_max_ins { get; set; }
        public Nullable<bool> tratar_como_triplo { get; set; }
        public Nullable<double> compl_comprimento { get; set; }
        public Nullable<bool> somente_manter_regra { get; set; }
        public Nullable<bool> nao_deixar_modulo_central { get; set; }
        public Nullable<bool> nao_deixar_modulo_parede { get; set; }
        public Nullable<int> GOND_UTILIZADO_EM { get; set; }
    }
}
