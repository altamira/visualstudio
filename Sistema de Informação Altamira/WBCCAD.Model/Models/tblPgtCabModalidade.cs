using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tblPgtCabModalidade
    {
        public int idTblPgtCabModalidade { get; set; }
        public string Modalidade { get; set; }
        public string Observacoes { get; set; }
        public bool Ativa { get; set; }
    }
}
