using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Config
{
    public class Bank
    {
        private int code;
        private string name;

        /// <summary>
        /// Registra o Código do Banco
        /// </summary>
        public int Code
        {
            get
            {
                return code;
            }
            set
            {
                code = value;
            }
        }

        /// <summary>
        /// Registra o Nome do Banco
        /// </summary>
        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }

        public Bank()
        {
            code = 237;
            name = "Bradesco";
        }
    }
}
