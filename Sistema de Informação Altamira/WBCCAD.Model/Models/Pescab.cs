using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Pescab
    {
        public int pescab_codigo { get; set; }
        public string pescab_nome { get; set; }
        public string pescab_lc_especie { get; set; }
        public string pescab_lc_endereco { get; set; }
        public string pescab_lc_numero { get; set; }
        public string pescab_lc_complemento { get; set; }
        public string pescab_lc_bairro { get; set; }
        public string pescab_lc_municipio { get; set; }
        public string pescab_uf { get; set; }
        public Nullable<int> pescab_cep { get; set; }
        public string pescab_ie { get; set; }
        public string pescab_rg { get; set; }
        public string pescab_im { get; set; }
        public string pescab_suframa { get; set; }
        public string pescab_ramo { get; set; }
        public Nullable<int> pescab_visita { get; set; }
        public string PAISCODIGO { get; set; }
        public string PESCAB_CONTATO { get; set; }
        public string PESCAB_FONE { get; set; }
        public string PESCAB_FAX { get; set; }
        public string PESCAB_EMAIL { get; set; }
        public Nullable<int> pescab_cob_cep { get; set; }
        public string pescab_cob_especie { get; set; }
        public string pescab_cob_endereco { get; set; }
        public string pescab_cob_numero { get; set; }
        public string pescab_cob_complemento { get; set; }
        public string pescab_cob_bairro { get; set; }
        public string pescab_cob_municipio { get; set; }
        public string pescab_cob_uf { get; set; }
        public string pescab_integracao { get; set; }
        public string PESCAB_CODINOME { get; set; }
        public Nullable<bool> concorrente { get; set; }
        public int idPescab { get; set; }
    }
}
