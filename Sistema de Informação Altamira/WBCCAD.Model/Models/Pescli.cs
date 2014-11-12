using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Pescli
    {
        public int pescli_codigo { get; set; }
        public string pescli_et_especie { get; set; }
        public string pescli_et_endereco { get; set; }
        public string pescli_et_numero { get; set; }
        public string pescli_et_complemento { get; set; }
        public string pescli_et_bairro { get; set; }
        public string pescli_et_municipio { get; set; }
        public string pescli_et_uf { get; set; }
        public Nullable<int> pescli_et_cep { get; set; }
        public string pescli_cb_especie { get; set; }
        public string pescli_cb_endereco { get; set; }
        public string pescli_cb_numero { get; set; }
        public string pescli_cb_complemento { get; set; }
        public string pescli_cb_bairro { get; set; }
        public string pescli_cb_municipio { get; set; }
        public string pescli_cb_uf { get; set; }
        public Nullable<int> pescli_cb_cep { get; set; }
        public Nullable<double> pescli_comissao { get; set; }
        public string pescli_categoria { get; set; }
        public string pescli_status { get; set; }
        public int idPescli { get; set; }
    }
}
