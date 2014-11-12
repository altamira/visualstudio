using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_rest
    {
        public int id_restricao { get; set; }
        public Nullable<int> quem_corte { get; set; }
        public string oque { get; set; }
        public string tipo_rest { get; set; }
        public string obj_rest { get; set; }
        public string quem_cjto { get; set; }
        public string quem_aces { get; set; }
        public Nullable<bool> todos_quem { get; set; }
        public Nullable<bool> todos_com_quem { get; set; }
        public Nullable<bool> e_ou { get; set; }
    }
}
