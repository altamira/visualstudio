using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class cam_detalhes_kit
    {
        public string apelido { get; set; }
        public bool DEPENDE_ESPESSURA { get; set; }
        public bool DEPENDE_ACABAMENTO { get; set; }
        public Nullable<int> QUANTIDADE_PAINEIS { get; set; }
        public Nullable<int> ANGULO_ENTRE_PAINEIS { get; set; }
        public string PAREDE_VIZINHO { get; set; }
        public string POSICAO_PAINEL { get; set; }
        public bool ESPESSURAS_IGUAIS { get; set; }
        public bool DEPENDE_TIPO_PAINEL { get; set; }
        public string QUAL_ACABAMENTO { get; set; }
        public string QUAL_TIPO { get; set; }
        public string desenho { get; set; }
        public bool somente_para_coluna { get; set; }
        public bool somente_para_divisoria { get; set; }
        public bool somente_alturas_diferentes { get; set; }
        public bool somente_reentrancia { get; set; }
        public bool somente_detalhe_piso { get; set; }
        public Nullable<double> valor_adicional { get; set; }
        public bool somente_quebra_frio { get; set; }
    }
}
