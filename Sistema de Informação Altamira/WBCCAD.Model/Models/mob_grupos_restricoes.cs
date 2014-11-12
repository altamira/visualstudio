using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mob_grupos_restricoes
    {
        public string grupoSelecionado { get; set; }
        public string gruporestringir { get; set; }
        public Nullable<bool> Incluirgruporestringir { get; set; }
        public Nullable<bool> existegruposelecionado { get; set; }
        public int idMobGrupoRestricoes { get; set; }
    }
}
