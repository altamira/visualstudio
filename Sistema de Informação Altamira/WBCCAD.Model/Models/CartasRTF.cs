using System;
using System.Collections.Generic;

namespace WBCCAD.Model.Models
{
    public partial class CartasRTF
    {
        public int idCartaRTF { get; set; }
        public string Carta { get; set; }
        public string RTF { get; set; }
        public byte[] RTFImagem { get; set; }
        public string numeroOrcamento { get; set; }
    }
}
