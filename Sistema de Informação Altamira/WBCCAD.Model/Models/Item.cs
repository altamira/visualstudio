using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class Item
    {
        public int idItem { get; set; }
        public Nullable<int> idRelatorio { get; set; }
        public Nullable<int> idSecao { get; set; }
        public Nullable<int> idTipoItem { get; set; }
        public string Item1 { get; set; }
        public string Campo { get; set; }
        public Nullable<int> Ordem { get; set; }
        public string Valor { get; set; }
    }
}
