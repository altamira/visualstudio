using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tblDados_projeto
    {
        public int IdOpcao { get; set; }
        public string DescricaoChave { get; set; }
        public string chaveValor { get; set; }
        public string grupo { get; set; }
        public string lista { get; set; }
        public bool Alterar_no_projeto { get; set; }
        public bool inativo { get; set; }
        public string codigochave { get; set; }
        public bool Somente_administrador { get; set; }
        public string Perfil { get; set; }
    }
}
