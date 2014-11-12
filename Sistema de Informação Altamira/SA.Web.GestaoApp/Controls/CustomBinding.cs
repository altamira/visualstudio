using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace GestaoApp.Controls
{
    internal class CustomBinding
    {
        private static Thickness InvalidDefaultBorderThicknessTooptip()
        {
            return new Thickness(2);
        }

        private static Brush InvalidDefaultForegroundTooptip()
        {
            return new SolidColorBrush(Colors.White);
        }

        private static Brush InvalidDefaultBackgroundTooptip()
        {
            return new SolidColorBrush(Colors.Red);
        }

        private static Brush InvalidDefaultBorderBrushTooptip()
        {
            return new SolidColorBrush(Colors.Red);
        }
        public static Brush DeFaultBorder
        {
            get { return new SolidColorBrush(Color.FromArgb(255, 101, 147, 217)); }
        }
        private static Brush InvalidDefaultBorder()
        {
            return new SolidColorBrush(Colors.Red);
        }

        private static Brush ValidDefaultBorder
        {
            get;
            set;
        }

        private static Thickness ValidDefaultBorderThickness
        {
            get;
            set;
        }

        private static ToolTip ValidDefaultToolTip
        {
            get;
            set;
        }

        private static Thickness InvalidDefaultBorderThickness()
        {
            return new Thickness(1);
        }

        public static void GoToValidState(FrameworkElement element,Brush borderBrush,Thickness borderThickness,ToolTip tooltip)
        {
            if (element is TextBox)
            {
                TextBox txt = element as TextBox;

                txt.BorderBrush = borderBrush;// ValidatorCommon.ValidDefaultBorder;
                txt.BorderThickness = borderThickness;//ValidatorCommon.ValidDefaultBorderThickness;
                //ToolTipService.SetToolTip(txt, ValidatorCommon.ValidDefaultToolTip);
                ToolTipService.SetToolTip(txt,tooltip);
            }
            else if (element is Border)
            {
                Border border = element as Border;

                border.BorderBrush = borderBrush;// ValidatorCommon.ValidDefaultBorder;
                border.BorderThickness = borderThickness;//ValidatorCommon.ValidDefaultBorderThickness;
                //ToolTipService.SetToolTip(txt, ValidatorCommon.ValidDefaultToolTip);
                ToolTipService.SetToolTip(border, tooltip);
            }
            else if (element is DatePicker)
            {
                DatePicker dp = element as DatePicker;

                dp.BorderBrush = borderBrush;
                dp.BorderThickness = borderThickness;
               
                ToolTipService.SetToolTip(dp, tooltip);
            }
            //else if (element is TimePicker)
            //{
            //    TimePicker tp = element as TimePicker;

            //    tp.BorderBrush = borderBrush;
            //    tp.BorderThickness = borderThickness;

            //    ToolTipService.SetToolTip(tp, tooltip);
            //}
            
        }

        public static void GoToInValidState(FrameworkElement element,string errorMessage)
        {
            if (element is TextBox)
            {
                TextBox txt = element as TextBox;

                txt.BorderBrush = InvalidDefaultBorder();
                txt.BorderThickness = InvalidDefaultBorderThickness();

                List<string> lstError = new List<string>();
                lstError.Add(errorMessage);
                CreateTooltip(txt,lstError);
            }
            else if (element is Border)
            {
                Border border = element as Border;

                border.BorderBrush = InvalidDefaultBorder();
                border.BorderThickness = InvalidDefaultBorderThickness();

                List<string> lstError = new List<string>();
                lstError.Add("Required!");
                CreateTooltip(border, lstError);
            }
            else if (element is DatePicker)
            {
                DatePicker dp = element as DatePicker;

                dp.BorderBrush = InvalidDefaultBorder();
                dp.BorderThickness = InvalidDefaultBorderThickness();

                List<string> lstError = new List<string>();
                lstError.Add("Required!");
                CreateTooltip(dp, lstError);
            }
            //else if (element is TimePicker)
            //{
            //    TimePicker tp = element as TimePicker;

            //    tp.BorderBrush = InvalidDefaultBorder();
            //    tp.BorderThickness = InvalidDefaultBorderThickness();

            //    List<string> lstError = new List<string>();
            //    lstError.Add("Required!");
            //    CreateTooltip(tp, lstError);
            //}
        }

        private static void CreateTooltip(FrameworkElement element, List<string> Errors)
        {
            StackPanel sp = new StackPanel();
            sp.Orientation = Orientation.Vertical;
            foreach (var item in Errors)
            {
                sp.Children.Add(new TextBlock() { Text = item, Foreground = new SolidColorBrush(Colors.White), Margin = new Thickness(5, 2, 5, 2) });
            }
            ToolTip tp = new ToolTip();
            tp.Opacity = 0;
            tp.Opened += new RoutedEventHandler(tp_Opened);
           
            tp.SetValue(ToolTip.ForegroundProperty, InvalidDefaultForegroundTooptip());
           
            tp.SetValue(ToolTip.BackgroundProperty, InvalidDefaultBackgroundTooptip());
           
            tp.SetValue(ToolTip.BorderBrushProperty, InvalidDefaultBorderBrushTooptip());
           
            tp.SetValue(ToolTip.BorderThicknessProperty, InvalidDefaultBorderThicknessTooptip());
            
            tp.SetValue(ToolTip.ContentProperty, sp);
            ToolTipService.SetToolTip(element, tp);
        }

        private static void tp_Opened(object sender, RoutedEventArgs e)
        {
            Storyboard sb = new Storyboard();
            DoubleAnimation db = new DoubleAnimation();
            db.From = 0;
            db.To = 1;
            db.Duration = TimeSpan.FromMilliseconds(800);
            sb.Duration = TimeSpan.FromSeconds(800);
            sb.Children.Add(db);
            Storyboard.SetTarget(db, (ToolTip)sender);
            Storyboard.SetTargetProperty(db, new PropertyPath("(Opacity)"));
            sb.Begin();
        }

      
    }
}
