using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mob_cadastro_caracteristicas
    {
        public string tipo { get; set; }
        public string caracteristica { get; set; }
        public string descricao { get; set; }
        public string sigla { get; set; }
        public Nullable<bool> e_padrao { get; set; }
        public int idMobCadastroCaracteristicas { get; set; }
    }
}
