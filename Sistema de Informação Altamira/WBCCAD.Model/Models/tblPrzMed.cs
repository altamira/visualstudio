using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tblPrzMed
    {
        public int idTblPrzMed { get; set; }
        public Nullable<int> PrzMed_Dias { get; set; }
        public Nullable<decimal> PrzMed_Fator { get; set; }
    }
}
