using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;


namespace GestaoApp.Controls
{
    [TemplatePart(Name = "TextElement", Type = typeof(TextBlock))]
    [TemplatePart(Name = "UpButtonElement", Type = typeof(RepeatButton))]
    [TemplatePart(Name = "DownButtonElement", Type = typeof(RepeatButton))]
    [TemplateVisualState(Name = "Positive", GroupName = "ValueStates")]
    [TemplateVisualState(Name = "Negative", GroupName = "ValueStates")]
    [TemplateVisualState(Name = "Focused", GroupName = "FocusedStates")]
    [TemplateVisualState(Name = "Unfocused", GroupName = "FocusedStates")]
    public class NumericUpDown : Control
    {
        public NumericUpDown()
        {
            DefaultStyleKey = typeof(NumericUpDown);
            this.IsTabStop = true;
        }

        public static readonly DependencyProperty ValueProperty =
            DependencyProperty.Register("Value", typeof(int), typeof(NumericUpDown),
                            new PropertyMetadata(new PropertyChangedCallback(ValueChangedCallback)));


        private static void ValueChangedCallback(DependencyObject obj, DependencyPropertyChangedEventArgs args)
        {
            NumericUpDown ctl = (NumericUpDown)obj;
            int newValue = (int)args.NewValue;

            // Update the TextElement to the new value.
            if (ctl.TextElement != null)
            {
                ctl.TextElement.Text = newValue.ToString();
            }

            // Call UpdateStates because the Value might have caused the
            // control to change ValueStates.
            ctl.UpdateStates(true);

            // Raise the ValueChanged event so applications can be alerted
            // when Value changes.
            ValueChangedEventArgs e = new ValueChangedEventArgs(newValue);
            ctl.OnValueChanged(e);
        }


        public event ValueChangedEventHandler ValueChanged;

        protected virtual void OnValueChanged(ValueChangedEventArgs e)
        {
            ValueChangedEventHandler handler = ValueChanged;

            if (handler != null)
            {
                handler(this, e);
            }
        }

        private void UpdateStates(bool useTransitions)
        {
            if (Value >= 0)
            {
                VisualStateManager.GoToState(this, "Positive", useTransitions);
            }
            else
            {
                VisualStateManager.GoToState(this, "Negative", useTransitions);
            }

            if (isFocused)
            {
                VisualStateManager.GoToState(this, "Focused", useTransitions);
            }
            else
            {
                VisualStateManager.GoToState(this, "Unfocused", useTransitions);
            }

        }

        public int Value
        {
            get
            {
                return (int)GetValue(ValueProperty);
            }

            set
            {
                SetValue(ValueProperty, value);

            }
        }


        public override void OnApplyTemplate()
        {
            UpButtonElement = GetTemplateChild("UpButton") as RepeatButton;
            DownButtonElement = GetTemplateChild("DownButton") as RepeatButton;
            TextElement = GetTemplateChild("TextBlock") as TextBlock;

            UpdateStates(false);
        }

        private TextBlock textElement;

        private TextBlock TextElement
        {
            get { return textElement; }

            set
            {
                textElement = value;

                if (textElement != null)
                {
                    textElement.Text = Value.ToString();
                    textElement.IsHitTestVisible = true;
                }
            }

        }

        private RepeatButton downButtonElement;

        private RepeatButton DownButtonElement
        {
            get
            {
                return downButtonElement;
            }

            set
            {
                if (downButtonElement != null)
                {
                    downButtonElement.Click -=
                        new RoutedEventHandler(downButtonElement_Click);
                }
                downButtonElement = value;

                if (downButtonElement != null)
                {
                    downButtonElement.Click +=
                        new RoutedEventHandler(downButtonElement_Click);
                }
            }
        }

        void downButtonElement_Click(object sender, RoutedEventArgs e)
        {
            Value--;
        }

        private RepeatButton upButtonElement;

        private RepeatButton UpButtonElement
        {
            get
            {
                return upButtonElement;
            }

            set
            {
                if (upButtonElement != null)
                {
                    upButtonElement.Click -=
                        new RoutedEventHandler(upButtonElement_Click);
                }
                upButtonElement = value;

                if (upButtonElement != null)
                {
                    upButtonElement.Click +=
                        new RoutedEventHandler(upButtonElement_Click);
                }
            }
        }

        void upButtonElement_Click(object sender, RoutedEventArgs e)
        {
            Value++;
        }

        protected override void OnMouseLeftButtonDown(MouseButtonEventArgs e)
        {
            base.OnMouseLeftButtonDown(e);
            Focus();
        }

        bool isFocused;

        protected override void OnGotFocus(RoutedEventArgs e)
        {
            base.OnGotFocus(e);
            isFocused = true;
            UpdateStates(true);
        }

        protected override void OnLostFocus(RoutedEventArgs e)
        {
            base.OnLostFocus(e);
            isFocused = false;
            UpdateStates(true);
        }

    }


    public delegate void ValueChangedEventHandler(object sender, ValueChangedEventArgs e);

    public class ValueChangedEventArgs : EventArgs
    {
        private int _value;

        public ValueChangedEventArgs(int num)
        {
            _value = num;
        }

        public int Value
        {
            get { return _value; }
        }
    }
}
