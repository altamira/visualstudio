using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mob_cadastro_descricoes_sigla
    {
        public string descricao { get; set; }
        public string sigla { get; set; }
        public Nullable<double> par_p_compr { get; set; }
        public Nullable<double> par_p_prof { get; set; }
        public Nullable<double> par_p_alt { get; set; }
        public int idMobCadastroDescricoesSigla { get; set; }
    }
}
