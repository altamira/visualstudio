using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.WPF.Financial
{
    public class RequestCloseMessage
    {
        public RequestCloseMessage(bool? dialogResult)
            : this()
        {
            DialogResult = dialogResult;
        }

        public RequestCloseMessage()
        {
        }

        public bool? DialogResult { get; set; }
    }
}
