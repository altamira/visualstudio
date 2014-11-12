using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Config
{
    public class Holder
    {
        private string name;
    
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

        public Holder()
        {
            name = string.Empty;
        }
    }
}
