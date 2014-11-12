using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class check_list
    {
        public string descricao { get; set; }
        public string grupo { get; set; }
        public string imagem { get; set; }
        public string comando_executar { get; set; }
        public string lista_dados { get; set; }
        public bool opcao { get; set; }
        public Nullable<int> ordem { get; set; }
        public string Valor_padrao { get; set; }
        public Nullable<int> tempo_apresentacao { get; set; }
        public string Variavel_projeto { get; set; }
        public bool permitir_edicao { get; set; }
        public bool ativo { get; set; }
        public string tag_atributo { get; set; }
    }
}
