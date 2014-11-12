using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class ListaFatoresCalculo
    {
        public int idListaFatorCalculo { get; set; }
        public string ListaFatorCalculo { get; set; }
        public Nullable<bool> Ativa { get; set; }
        public Nullable<bool> Padrao { get; set; }
    }
}
