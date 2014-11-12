using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class prdfam
    {
        public string Familia { get; set; }
        public string Descricao { get; set; }
        public Nullable<int> IMPORTAR { get; set; }
        public string VARPRDESTLST { get; set; }
        public string FORMULA { get; set; }
        public int idPrdfam { get; set; }
        public string descritivoTecnico { get; set; }
    }
}
