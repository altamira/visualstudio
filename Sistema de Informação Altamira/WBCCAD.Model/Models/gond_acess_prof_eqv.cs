using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_acess_prof_eqv
    {
        public string descricao { get; set; }
        public string ang { get; set; }
        public string tipo_frente { get; set; }
        public Nullable<int> id_corte_frontal { get; set; }
        public Nullable<int> profundidade { get; set; }
        public Nullable<int> equivalencia { get; set; }
        public int idGondAcessProfEqv { get; set; }
    }
}
