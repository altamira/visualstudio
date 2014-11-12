using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Interactivity;
using GalaSoft.MvvmLight.Messaging;

namespace SA.WPF.Financial.Behavior 
{
    class DialogBehavior : Behavior<FrameworkElement>
    {
        IMessenger m = Messenger.Default;

        protected override void OnAttached()
        {
            base.OnAttached();

            m.Register<GalaSoft.MvvmLight.Messaging.DialogMessage>(this, Identifier, ShowDialog);
        }

        public string Identifier { get; set; }
        public string Caption { get; set; }
        public string Text { get; set; }
        public MessageBoxButton Buttons { get; set; }

        private void ShowDialog(GalaSoft.MvvmLight.Messaging.DialogMessage DialogMessage)
        {
            var result = MessageBox.Show(Text, Caption, Buttons);
            DialogMessage.Callback(result);
        }

    }
}
