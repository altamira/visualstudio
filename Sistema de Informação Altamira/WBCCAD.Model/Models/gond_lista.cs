using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gond_lista
    {
        public string lista { get; set; }
        public Nullable<bool> ESCONDER { get; set; }
        public Nullable<bool> esconder_perfil { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public string tipo_cad { get; set; }
        public string sufixo { get; set; }
        public Nullable<bool> pedir_dados_armazenagem { get; set; }
        public string base_padrao { get; set; }
        public string Utilizar_somente_para_este_perfil { get; set; }
        public Nullable<bool> Utilizar_travessas { get; set; }
        public int idGondLista { get; set; }
    }
}
