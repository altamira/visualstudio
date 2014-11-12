using FirstFloor.ModernUI.Windows;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace MefMuiApp
{
    [MetadataAttribute]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = false)]
    public class CommandAttribute
        : ExportAttribute
    {
        public CommandAttribute(string commandUri)
            : base(typeof(ICommand))
        {
            this.CommandUri = commandUri;
        }
        public string CommandUri { get; private set; }
    }
}
