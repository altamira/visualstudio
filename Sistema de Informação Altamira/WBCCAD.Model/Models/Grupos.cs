using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Grupos
    {
        public int idGrupo { get; set; }
        public int idNivel { get; set; }
        public string Grupo { get; set; }
        public string Observacoes { get; set; }
        public Nullable<bool> Ativo { get; set; }
    }
}
