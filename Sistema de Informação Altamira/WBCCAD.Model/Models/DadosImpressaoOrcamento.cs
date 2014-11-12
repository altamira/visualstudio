using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class DadosImpressaoOrcamento
    {
        public int idDadosOrcamento { get; set; }
        public string Chave { get; set; }
        public string Descricao { get; set; }
        public string Valores { get; set; }
        public string valorPadrao { get; set; }
        public string Referente { get; set; }
        public bool Ativo { get; set; }
        public string DescricaoGrupo { get; set; }
    }
}
