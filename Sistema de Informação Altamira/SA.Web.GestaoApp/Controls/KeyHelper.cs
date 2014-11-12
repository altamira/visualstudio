using System;
using System.Windows.Input;
using System.Globalization;

namespace GestaoApp.Controls
{
    /// <summary>
    /// Enumerator to identify the type of mask
    /// </summary>
    internal enum MaskType
    {
        None,
        Numeric,
        Letter,
        Custom,
        NumericCustom,
        LetterCustom,
        Any
    }


    /// <summary>
    /// Key Input Helpper
    /// </summary>
    internal static class KeyHelper
    {
        /// <summary>
        /// Checker value X Mask
        /// </summary>
        /// <param name="Mask">Mask input</param>
        /// <param name="Value">Data input</param>
        /// <param name="CustomKeys">Extra Chars to compare</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if position is valid for Mask</returns>
        public static bool IsValidKeyAtPos(char Mask,string Value, string CustomKeys)
        {
            MaskType type = GetTypeInput(Mask);
            bool result = false;
            switch (type)
            {
                case MaskType.Numeric:
                    result = IsNumberKey(Value);
                    break;
                case MaskType.Letter:
                    result = IsLetterKey(Value);
                    break;
                case MaskType.Custom:
                    result = IsCustomKey(Value, CustomKeys);
                    break;
                case MaskType.NumericCustom:
                    {
                        result = IsNumberKey(Value);
                        if (!result)
                        {
                            result = IsCustomKey(Value, CustomKeys);
                        }
                    }
                    break;
                case MaskType.LetterCustom:
                    {
                        result = IsLetterKey(Value);
                        if (!result)
                        {
                            result = IsCustomKey(Value, CustomKeys);
                        }
                    }
                    break;
                case MaskType.Any:
                    result = true;
                    break;
            }
            return result;
        }

        /// <summary> 
        /// Convert Mask input to enumerator Masktype
        /// </summary>
        /// <param name="Mask">Mask input</param>
        /// <returns>Masktype Enumerator to input</returns>
        private static MaskType GetTypeInput(char Mask)
        {
            if (Mask == '9') return MaskType.Numeric;
            if (Mask == 'A') return MaskType.Letter;
            if (Mask == 'C') return MaskType.Custom;
            if (Mask == 'Z') return MaskType.NumericCustom;
            if (Mask == '#') return MaskType.LetterCustom;
            if (Mask == 'X') return MaskType.Any;
            return MaskType.None;
        }

        /// <summary>
        /// if key pressed are a directional move
        /// </summary>
        /// <param name="key">Key Enumerator</param>
        /// <returns>True if Key is a directional move valid</returns>
        public static bool IsMoveKey(Key key)
        {
            switch (key)
            {
                case Key.Left:
                case Key.Right:
                case Key.Home:
                case Key.End:
                case Key.PageDown:
                case Key.PageUp:
                    return true;
            }
            return false;
        }

        /// <summary>
        /// if key pressed are paste action from clipboad
        /// </summary>
        /// <param name="key">Key Enumerator</param>
        /// <returns>True if paste action</returns>
        public static bool IsClipboadPaste(Key key)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool ShiftPress = ((Keyboard.Modifiers & ModifierKeys.Shift) == ModifierKeys.Shift);
            if (CtrlPress && key == Key.V)
            {
                return true;
            }
            if (ShiftPress && key == Key.Insert)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// if input char is Positive Signal
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Positive Signal</returns>
        public static bool IsPositiveSignal(string value, CultureInfo Culture)
        {
            string s = CultureHelper.GetPositiveSignal(Culture);
            return (s == value);
        }

        /// <summary>
        /// if input char is Negative Signal
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture"></param>
        /// <returns>True if Is Negative Signal</returns>
        public static bool IsNegativeSignal(string value, CultureInfo Culture)
        {
            string s = CultureHelper.GetNegativeSignal(Culture);
            return (s == value);
        }

        /// <summary>
        /// if input char is AM Signal
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture"></param>
        /// <returns>True if Is AM Signal</returns>
        public static bool IsAMSignal(string value, CultureInfo Culture)
        {
            string s = CultureHelper.GetAMplaceholder(Culture);
            if (s.Length == 0) return false;
            return (s.Substring(0,1).ToUpper() == value.ToUpper());
        }

        /// <summary>
        /// if input char is AM Signal
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture"></param>
        /// <returns>True if Is AM Signal</returns>
        public static bool IsPMSignal(string value, CultureInfo Culture)
        {
            string s = CultureHelper.GetPMplaceholder(Culture);
            if (s.Length == 0) return false;
            return (s.Substring(0, 1).ToUpper() == value.ToUpper());
        }

        /// <summary>
        /// if key pressed is Signal Positive/negative
        /// </summary>
        /// <param name="key">Key enumerator</param>
        /// <param name="PlatformKeyCode">Keycode</param>
        /// <returns>True if is Positive/negative or Unknown</returns>
        public static bool IsSignalKeyPreview(Key key)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool AltPress = ((Keyboard.Modifiers & ModifierKeys.Alt) == ModifierKeys.Alt);

            if (CtrlPress || AltPress)
            {
                return false;
            }
            if (key == Key.Add || key == Key.Subtract || key == Key.Unknown)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// if key pressed is Decimal placehold
        /// </summary>
        /// <param name="key">Key enumerator</param>
        /// <param name="PlatformKeyCode">Keycode</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Decimal pressed or Unknown</returns>
        public static bool IsDecimalKeyPreview(Key key)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool AltPress = ((Keyboard.Modifiers & ModifierKeys.Alt) == ModifierKeys.Alt);

            if (CtrlPress || AltPress)
            {
                return false;
            }
            if (key == Key.Decimal || key == Key.Unknown)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// if key pressed is Decimal placehold
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Decimal pressed</returns>
        public static bool IsDecimalPlacehoder(string value, CultureInfo Culture)
        {
            string D = CultureHelper.GetDecimalplaceholder(Culture);
            return (D == value);
        }

        /// <summary>
        /// if key pressed is Date placeholder
        /// </summary>
        /// <param name="key">Key enumerator</param>
        /// <param name="PlatformKeyCode">Keycode</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Date placeholder pressed or Unknown</returns>
        public static bool IsDateplaceholderKeyPreview(Key key)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool AltPress = ((Keyboard.Modifiers & ModifierKeys.Alt) == ModifierKeys.Alt);

            if (CtrlPress || AltPress)
            {
                return false;
            }
            if (key == Key.Divide || key == Key.Subtract || key == Key.Unknown)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// if key pressed is Date Separator
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Date Separator</returns>
        public static bool IsDatePlaceholder(string value, CultureInfo Culture)
        {
            string D = CultureHelper.GetDateplaceholder(Culture);
            return (D == value);
        }

        /// <summary>
        /// if key pressed is Time placeholder
        /// </summary>
        /// <param name="key">Key enumerator</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Time placeholder pressed</returns>
        public static bool IsTimeplaceholderKeyPreview(Key key)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool AltPress = ((Keyboard.Modifiers & ModifierKeys.Alt) == ModifierKeys.Alt);

            if (CtrlPress || AltPress)
            {
                return false;
            }
            if (key == Key.Unknown)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// if key pressed is AM/PM symbol
        /// </summary>
        /// <param name="key">Key enumerator</param>
        /// <returns>True if is Time placeholder pressed</returns>
        public static bool IsAMPMKeyPreview(Key key,CultureInfo Culture)
        {
            bool CtrlPress = ((Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control);
            bool AltPress = ((Keyboard.Modifiers & ModifierKeys.Alt) == ModifierKeys.Alt);

            if (CtrlPress || AltPress)
            {
                return false;
            }
            if (key == Key.Unknown)
            {
                return false;
            }
            string[] AmPm = CultureHelper.GetAMPMplaceholders(Culture);
            if (AmPm[0].Length > 0 && AmPm[1].Length > 0)
            {
                if (AmPm[0].Substring(0, 1).ToUpper() == "A" && AmPm[1].Substring(0, 1).ToUpper() == "P")
                {
                    if (key == Key.A || key == Key.P)
                    {
                        return true;
                    }
                    return false;
                }
            }
            return true;
        }


        /// <summary>
        /// if key pressed is Date Separator
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Date Separator</returns>
        public static bool IsTimePlaceholder(string value, CultureInfo Culture)
        {
            string T = CultureHelper.GetTimeplaceholder(Culture);
            return (T == value);
        }

        /// <summary>
        /// if the value contained in Custom chars
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Custom">Extra chars to compare</param>
        /// <returns>True if is contained in Custom</returns>
        public static bool IsCustomKey(string value,string Custom)
        {
            if (String.IsNullOrEmpty(Custom)) return false;
            return (Custom.IndexOf(value) >= 0);
        }

        /// <summary>
        /// if the value is numeric
        /// </summary>
        /// <param name="value">input</param>
        /// <returns>True if is number</returns>
        public static bool IsNumberKey(string value)
        {
            return ("0123456789".IndexOf(value) >= 0);
        }

        /// <summary>
        /// if the value is Letter or Space
        /// </summary>
        /// <param name="value">input</param>
        /// <returns>True if is Letter or space</returns>
        public static bool IsLetterSpaceKey(string value)
        {
            if (value == " ") return true;
            return IsLetterKey(value);
        }

        /// <summary>
        /// if the value is Positive or Negative Symbol
        /// </summary>
        /// <param name="value">input</param>
        /// <param name="Culture">CultureInfo</param>
        /// <returns>True if is Positive or negative</returns>
        public static bool IsSignalKey(string value, CultureInfo Culture)
        {
            string S = CultureHelper.GetNegativeSignal(Culture);
            if (S == value) return true;
            S = CultureHelper.GetPositiveSignal(Culture);
            if (S == value) return true;
            return false;
        }

        /// <summary>
        /// if the value is letter
        /// </summary>
        /// <param name="value">input</param>
        /// <returns>True if is letter</returns>
        public static bool IsLetterKey(string value)
        {
            return ("abcdefghijklmnopqrstuvxyzw".IndexOf(value.ToLower()) >= 0);
        }

        public static bool isDigitPress(Key key)
        {
            if (Keyboard.Modifiers != ModifierKeys.Shift)
                switch (key)
                {
                    case Key.D0:
                    case Key.D1:
                    case Key.D2:
                    case Key.D3:
                    case Key.D4:
                    case Key.D5:
                    case Key.D6:
                    case Key.D7:
                    case Key.D8:
                    case Key.D9:
                    case Key.NumPad0:
                    case Key.NumPad1:
                    case Key.NumPad2:
                    case Key.NumPad3:
                    case Key.NumPad4:
                    case Key.NumPad5:
                    case Key.NumPad6:
                    case Key.NumPad7:
                    case Key.NumPad8:
                    case Key.NumPad9:
                        return true;
                    default:
                        return false;
                }
            else
                return false;

            //if ((key > Key.D0 && key < Key.D9) || (key > Key.NumPad0 && key < Key.NumPad9))
            //    return true;
            //else
            //    return false;
        }
    }
}
