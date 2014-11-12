using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Usuario
    {
        public int idUsuario { get; set; }
        public string Usuario1 { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public string Prefixo { get; set; }
        public string Observacoes { get; set; }
        public bool Ativo { get; set; }
        public string descontoMax { get; set; }
    }
}
