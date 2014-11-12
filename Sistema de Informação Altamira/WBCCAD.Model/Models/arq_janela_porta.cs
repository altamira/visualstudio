using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class arq_janela_porta
    {
        public string descricao { get; set; }
        public string desenho { get; set; }
        public Nullable<int> medida_comprimento { get; set; }
        public string tipo { get; set; }
        public bool espelhar_1 { get; set; }
        public Nullable<int> medida_altura { get; set; }
        public bool espelhar_2 { get; set; }
        public Nullable<double> Altura_peitoril { get; set; }
    }
}
