using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class gab_gabacsg
    {
        public string corte { get; set; }
        public string acessorio { get; set; }
        public Nullable<double> qtde_minima { get; set; }
        public Nullable<double> qtde_maxima { get; set; }
        public Nullable<int> opcional { get; set; }
        public Nullable<int> dependencia { get; set; }
        public Nullable<double> qtde_default { get; set; }
        public Nullable<int> altura_util { get; set; }
        public Nullable<int> potencia { get; set; }
        public Nullable<bool> visivel { get; set; }
        public Nullable<int> prioridade { get; set; }
        public Nullable<bool> esconder_orcamento { get; set; }
        public string Insercao { get; set; }
        public Nullable<int> altura_inicial { get; set; }
        public Nullable<int> distancia_entre_niveis { get; set; }
        public Nullable<bool> multiplo_por_modulo { get; set; }
        public Nullable<int> comprimento_fixo { get; set; }
        public Nullable<double> afastamento_fundo { get; set; }
        public Nullable<bool> travar_representante { get; set; }
        public Nullable<int> altura_fixa { get; set; }
        public int idGabGabacsg { get; set; }
    }
}
