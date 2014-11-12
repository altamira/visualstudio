using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_cjtos
    {
        public string descricao_cjto { get; set; }
        public Nullable<bool> dep_compr { get; set; }
        public Nullable<bool> dep_alt { get; set; }
        public Nullable<bool> dep_frente { get; set; }
        public Nullable<bool> dep_frontal { get; set; }
        public Nullable<bool> dep_posicao { get; set; }
        public Nullable<bool> dep_prof { get; set; }
        public Nullable<bool> ig_auto { get; set; }
        public Nullable<bool> dep_prof_outro_lado { get; set; }
        public Nullable<int> ANGULO_INCLINACAO { get; set; }
        public string mensagem_nao_padrao { get; set; }
        public int idGondCjtos { get; set; }
        public Nullable<bool> travar_representante { get; set; }
    }
}
