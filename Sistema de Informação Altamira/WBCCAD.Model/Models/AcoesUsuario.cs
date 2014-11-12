using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class AcoesUsuario
    {
        public int idAcaoUsuario { get; set; }
        public int idAcao { get; set; }
        public int idUsuario { get; set; }
        public bool Permitir { get; set; }
    }
}
