using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class mob_aces
    {
        public string Descricao_principal { get; set; }
        public string descricao_acess { get; set; }
        public Nullable<int> qtde_min { get; set; }
        public Nullable<int> qtde_max { get; set; }
        public Nullable<int> qtde_pad { get; set; }
        public Nullable<int> obrigatorio { get; set; }
        public Nullable<int> consumo_eletrico { get; set; }
        public Nullable<double> desl_x { get; set; }
        public Nullable<double> desl_y { get; set; }
        public Nullable<double> rotacao { get; set; }
        public Nullable<bool> espelhar { get; set; }
        public Nullable<double> desl_z { get; set; }
        public Nullable<bool> tratar_por_chave { get; set; }
        public Nullable<bool> Cor_altera_codigo { get; set; }
        public Nullable<bool> possui_tensao { get; set; }
        public Nullable<bool> possui_frequencia { get; set; }
        public Nullable<bool> possui_parametro4 { get; set; }
        public Nullable<bool> possui_parametro5 { get; set; }
        public Nullable<double> comprimento_entre_acessorios { get; set; }
        public Nullable<int> tipo_distribuicao { get; set; }
        public int idMobAces { get; set; }
    }
}
