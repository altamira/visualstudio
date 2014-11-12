using FirstFloor.ModernUI.Windows.Navigation;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace MefMuiApp
{
    /// <summary>
    /// Extends the default link navigator by adding exported ICommands.
    /// </summary>
    [Export]
    public class MefLinkNavigator
        : DefaultLinkNavigator, IPartImportsSatisfiedNotification
    {
        [ImportMany]
        private Lazy<ICommand, ICommandMetadata>[] ImportedCommands { get; set; }

        public void OnImportsSatisfied()
        {
            // add the imported commands to the command dictionary
            foreach (var c in this.ImportedCommands) {
                var commandUri = new Uri(c.Metadata.CommandUri, UriKind.RelativeOrAbsolute);
                this.Commands.Add(commandUri, c.Value);
            }
        }
    }
}
