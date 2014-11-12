using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Aplicaco
    {
        public int idAplicacao { get; set; }
        public string AplicacaoPT { get; set; }
        public string AplicacaoEN { get; set; }
        public string AplicacaoES { get; set; }
        public string Executavel { get; set; }
        public string Parametros { get; set; }
        public string Observacoes { get; set; }
        public bool Ativa { get; set; }
        public bool Principal { get; set; }
        public bool ArquivosPrograma { get; set; }
        public string chave { get; set; }
    }
}
