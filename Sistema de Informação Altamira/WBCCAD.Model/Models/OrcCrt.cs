using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class OrcCrt
    {
        public string numeroOrcamento { get; set; }
        public Nullable<decimal> orccrt_altura { get; set; }
        public Nullable<decimal> orccrt_altura_base { get; set; }
        public Nullable<decimal> orccrt_largura { get; set; }
        public Nullable<decimal> orccrt_profundidade { get; set; }
        public Nullable<decimal> orccrt_cabeceiras { get; set; }
        public Nullable<decimal> orccrt_cap_termica { get; set; }
        public string orccrt_corte { get; set; }
        public Nullable<decimal> orccrt_decibeis { get; set; }
        public string orccrt_departamento { get; set; }
        public Nullable<decimal> orccrt_estrutura { get; set; }
        public Nullable<decimal> orccrt_folga { get; set; }
        public Nullable<int> orccrt_grupo { get; set; }
        public Nullable<decimal> orccrt_hp { get; set; }
        public Nullable<decimal> orccrt_largura_cabeceira { get; set; }
        public string orccrt_nr_seq { get; set; }
        public string orccrt_setor { get; set; }
        public string orccrt_subgrupo { get; set; }
        public Nullable<decimal> orccrt_tipo_corte { get; set; }
        public string orccrt_utilizacao { get; set; }
        public Nullable<decimal> orccrt_valor_total { get; set; }
        public string orccrt_viz_atras { get; set; }
        public string orccrt_viz_final { get; set; }
        public string orccrt_viz_inicio { get; set; }
        public int idOrcCrt { get; set; }
        public string orccrt_item { get; set; }
    }
}
