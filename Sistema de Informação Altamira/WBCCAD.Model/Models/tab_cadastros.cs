using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tab_cadastros
    {
        public int indice { get; set; }
        public string descr_usu { get; set; }
        public string tabela { get; set; }
        public Nullable<bool> uso_interno { get; set; }
        public string tipo_cad { get; set; }
        public string tipo_usar { get; set; }
        public string tab_seg { get; set; }
        public string tab_tab1_tabseg { get; set; }
        public string tabela_chave { get; set; }
        public string tab_seg_chave { get; set; }
        public string Campo_ref_tab { get; set; }
        public string Campo_ref_seg { get; set; }
        public string formulario { get; set; }
    }
}
