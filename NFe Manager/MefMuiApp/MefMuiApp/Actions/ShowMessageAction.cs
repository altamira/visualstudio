using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.Prism.Interactivity.InteractionRequest;
using System.Windows.Interactivity;
using System.Windows;
using System.Windows.Controls;

namespace MefMuiApp.Actions
{
    public class ShowMessageAction : TriggerAction<FrameworkElement>
    {
        // element in view where message will be shown
        public static readonly DependencyProperty TitleBoxProperty =
           DependencyProperty.Register("TitleBox", typeof(TextBox),
              typeof(ShowMessageAction));

        public TextBox TitleBox
        {
            get { return (TextBox)GetValue(TitleBoxProperty); }
            set { SetValue(TitleBoxProperty, value); }
        }

        protected override void Invoke(object parameter)
        {
            InteractionRequestedEventArgs e =
               parameter as InteractionRequestedEventArgs;
            if (e != null)
            {
                if (TitleBox != null)
                {
                    TitleBox.Opacity = 1.0;
                    TitleBox.Text = e.Context.Title;
                    // TODO: for example, hide after some time
                }
            }
        }
    }
}
