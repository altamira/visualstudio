using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.ComponentModel;
using System.Reflection;

namespace SA.WPF.Financial.Extension
{
    public static class EnumExtensions
    {
        public static int ToInt(this System.Enum enumValue)
        {
            return (int)((object)enumValue);
        }
    }
}
