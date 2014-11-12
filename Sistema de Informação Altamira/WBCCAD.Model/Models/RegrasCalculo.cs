using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class RegrasCalculo
    {
        public int idRegraCalculo { get; set; }
        public Nullable<int> idListaFatorCalculo { get; set; }
        public Nullable<int> idTipoVenda { get; set; }
        public Nullable<int> idGrupoImposto { get; set; }
        public Nullable<int> idGrupo { get; set; }
        public Nullable<int> idSubgrupo { get; set; }
        public Nullable<int> idFormula { get; set; }
        public string descritivoRegra { get; set; }
    }
}
