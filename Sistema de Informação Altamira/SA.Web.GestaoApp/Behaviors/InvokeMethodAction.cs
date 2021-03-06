﻿using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Interactivity;

namespace GestaoApp.Behaviors.Triggers
{
    public class InvokeMethodAction : TargetedTriggerAction<UIElement>
    {
        protected override void Invoke(object parameter)
        {
            if (MethodToInvoke != null)
            {
                MethodToInvoke(Target, null);
            }
        }

        public delegate void Handler(object sender, RoutedEventArgs e);
        public event Handler MethodToInvoke;

    }
}
