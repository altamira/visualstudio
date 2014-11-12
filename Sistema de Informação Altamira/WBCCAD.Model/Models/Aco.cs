using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Aco
    {
        public int idAcao { get; set; }
        public Nullable<int> idAcaoPai { get; set; }
        public int idTipoAcao { get; set; }
        public int idAplicacao { get; set; }
        public string AcaoPT { get; set; }
        public string AcaoEN { get; set; }
        public string AcaoES { get; set; }
        public string Chave { get; set; }
        public string LinhaComando { get; set; }
        public string DiretorioInicial { get; set; }
        public string Parametros { get; set; }
        public string ObservacoesPT { get; set; }
        public string ObservacoesEN { get; set; }
        public string ObservacoesES { get; set; }
        public bool Exibir { get; set; }
    }
}
