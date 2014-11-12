using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class FatoresCalculo
    {
        public Nullable<int> idFator { get; set; }
        public Nullable<int> idListaFatorCalculo { get; set; }
        public string Fator { get; set; }
        public Nullable<int> ReferentePreco { get; set; }
        public bool Variavel { get; set; }
        public bool Visivel { get; set; }
        public bool PertenceListaPreco { get; set; }
        public Nullable<double> Valor { get; set; }
    }
}
