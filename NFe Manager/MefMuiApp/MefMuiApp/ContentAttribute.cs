using FirstFloor.ModernUI.Windows;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MefMuiApp
{
    [MetadataAttribute]
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class ContentAttribute
        : ExportAttribute
    {
        public ContentAttribute(string contentUri)
            : base(typeof(IContent))
        {
            this.ContentUri = contentUri;
        }
        public string ContentUri { get; private set; }
    }
}
