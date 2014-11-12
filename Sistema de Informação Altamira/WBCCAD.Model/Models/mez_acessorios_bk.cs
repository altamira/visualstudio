using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mez_acessorios_bk
    {
        public string formula_dimensao { get; set; }
        public string descricao { get; set; }
        public string codigo { get; set; }
        public string formula_quantidade { get; set; }
        public Nullable<int> dimensao_maxima_sem_juncao { get; set; }
        public string codigo_juncao { get; set; }
        public string tipo_cad { get; set; }
        public Nullable<int> multiplo { get; set; }
        public Nullable<int> comprimento_maximo { get; set; }
        public string tipo { get; set; }
        public bool vizinho { get; set; }
        public bool arredondar_baixo { get; set; }
        public bool ins_pis_metalic { get; set; }
        public Nullable<bool> Aces_des_por_Pontos { get; set; }
    }
}
