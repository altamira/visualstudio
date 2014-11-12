using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight.Messaging;

namespace SA.WPF.Financial.View
{
    public static class NotificationMessageView
    {
        public static void TransactionViewShow(NotificationMessage msg)
        {
            LancamentoView v = new LancamentoView();
            v.Show();
        }
    }
}
