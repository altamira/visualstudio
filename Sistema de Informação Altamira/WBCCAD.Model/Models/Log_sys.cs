using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Log_sys
    {
        public int AcaoNumero { get; set; }
        public Nullable<System.DateTime> Data { get; set; }
        public Nullable<System.DateTime> Hora { get; set; }
        public string Acao { get; set; }
        public string Modulo { get; set; }
        public string Usuário { get; set; }
        public string Supervisor { get; set; }
        public string Maquina { get; set; }
    }
}
