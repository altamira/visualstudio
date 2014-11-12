using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace GestaoApp.Controls
{
    public class NameTextbox : TextBox
    {
        #region Private Variables

       
        
        
        //set default values on control load
        Brush ValidBorderBrush;
        Thickness ValidBorderThickness;
        ToolTip ValidTooltip;

        //string _ErrorMessage="Name should be between MinLength and MaxLength!";
        //int _MinLength = 2;

        #endregion

        #region Constructor

        /// <summary>
        /// Constructor
        /// </summary>
        public NameTextbox() :base()
        {
            base.BorderBrush = CustomBinding.DeFaultBorder;
            base.BorderThickness = new Thickness(1);
            this.Loaded += new RoutedEventHandler(NameTextbox_Loaded);
        }
        #endregion

        #region Property

        //public string  ErrorMessage
        //{
        //    get { return _ErrorMessage; }

        //    set { _ErrorMessage = value; }
        //}

        public int MinLength
        {
            get { return (int)GetValue(MinLengthProperty); }
            set
            {
                SetValue(MinLengthProperty, value);

            }
        }
        public string ErrorMessage
        {
            get { return (string)GetValue(ErrorMessageProperty); }
            set
            {
                SetValue(ErrorMessageProperty, value);
            }  
        }
        public bool Required
        {
            //TODO RESET MASK AND INITIALIZE WHEN CHANGE AT RUNTIME
            get { return (bool)GetValue(RequiredProperty); }
            set
            {
                SetValue(RequiredProperty, value);
            }
        }

        public bool IsValid
        {
            get { return (bool)GetValue(IsValidProperty); }
            set
            {
                SetValue(IsValidProperty, value);

            }
        }
        #endregion

        #region Public Dependency Properties

        public static readonly DependencyProperty MinLengthProperty =
                DependencyProperty.Register("MinLength", typeof(int), typeof(NameTextbox), new PropertyMetadata(0));

        public static readonly DependencyProperty ErrorMessageProperty =
          DependencyProperty.Register("ErrorMessage", typeof(string), typeof(NameTextbox), new PropertyMetadata("Text Length should be between MinLength and MaxLength!"));

        public static readonly DependencyProperty RequiredProperty =
            DependencyProperty.Register("Required", typeof(bool), typeof(NameTextbox), new PropertyMetadata(false));

        public static readonly DependencyProperty IsValidProperty =
           DependencyProperty.Register("IsValid", typeof(bool), typeof(NameTextbox), new PropertyMetadata(true));
        #endregion

      

        #region events
        void NameTextbox_Loaded(object sender, RoutedEventArgs e)
        {
            //set default values on control load
            ValidBorderBrush = this.BorderBrush;
            ValidBorderThickness = this.BorderThickness;
            ValidTooltip = ToolTipService.GetToolTip(this) as ToolTip;

            base.LostFocus += new RoutedEventHandler(NameTextbox_LostFocus);
        }

        void NameTextbox_LostFocus(object sender, RoutedEventArgs e)
        {
            //base.OnLostFocus(e);

            this.IsValid  = CheckValidation();
        }
        #endregion

        #region override events

        protected override void OnKeyDown(KeyEventArgs e)
        {
            base.OnKeyDown(e);

            if (e.Key == Key.Tab | e.Key == Key.Delete | e.Key == Key.Back | e.Key == Key.Ctrl | KeyHelper.IsClipboadPaste(e.Key) | KeyHelper.IsMoveKey(e.Key) | e.Key==Key.Space)
                e.Handled = false;
            else if (!KeyHelper.IsLetterKey(e.Key.ToString()))
                e.Handled = true;
        }

        #endregion

        #region method
        private bool CheckValidation()
        {
            if (Required && (string.IsNullOrEmpty(this.Text.Trim())))
            {
                CustomBinding.GoToInValidState(this, "Required!");
                return false;
            }
            
             if (MaxLength == 0)
                {
                  if (this.Text.Length >= MinLength)
                     {
                        CustomBinding.GoToValidState(this, ValidBorderBrush,ValidBorderThickness, ValidTooltip);
                        return true;
                      }
                     else
                      {
                         CustomBinding.GoToInValidState(this, ErrorMessage);
                          return false;
                      }
                }
                else
                {
                   if (this.Text.Length >= MinLength & this.Text.Length <= MaxLength)
                     {
                       CustomBinding.GoToValidState(this, ValidBorderBrush, ValidBorderThickness, ValidTooltip);
                       return true;
                     }
                   else
                     {
                       CustomBinding.GoToInValidState(this, ErrorMessage);
                       return false;
                     }
                }
        }
        #endregion
    }
}
