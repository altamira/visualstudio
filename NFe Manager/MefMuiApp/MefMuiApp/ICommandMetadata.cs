using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MefMuiApp
{
    public interface ICommandMetadata
    {
        string CommandUri { get; }
    }
}
