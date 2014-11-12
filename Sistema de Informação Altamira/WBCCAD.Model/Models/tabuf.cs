using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class tabuf
    {
        public string tabuf_codigo { get; set; }
        public string tabuf_descricao { get; set; }
        public string GrupoImpostos { get; set; }
        public Nullable<double> tabuf_icms { get; set; }
        public Nullable<double> tabuf_icms_local { get; set; }
        public Nullable<double> Incluir_fator { get; set; }
        public Nullable<double> Retirar_fator { get; set; }
        public Nullable<int> tabuf_chave_cep { get; set; }
        public string tabuf_regiao { get; set; }
        public string PAISCODIGO { get; set; }
        public int idTabuf { get; set; }
    }
}
