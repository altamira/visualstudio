using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Pesusr
    {
        public Nullable<int> pesusr_codigo { get; set; }
        public string pesusr_senha { get; set; }
        public string pesusr_assinatura { get; set; }
        public bool pesusr_trocar_senha { get; set; }
        public Nullable<System.DateTime> pesusr_proxima_troca { get; set; }
        public bool pesusr_bloquear_acesso { get; set; }
        public Nullable<System.DateTime> pesusr_validade { get; set; }
        public bool pesusr_desabilitado { get; set; }
    }
}
