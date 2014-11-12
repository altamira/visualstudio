WPF Sample for Simple Mvvm Toolkit

This demonstrates how to use the Simple Mvvm Toolkit to create a WPF MVVM app.

The setup is basically the same as for the Siverlight Getting Started app,
the main difference being that you need to reference SimpleMvvmToolkit-WPF.

Add refences to System.Windows.Interactivity and Microsoft.Expression.Interactions
They can be found here:
C:\Program Files (x86)\Microsoft SDKs\Expression\Blend\.NETFramework\v4.0\Libraries

Don't forget to reference the namespaces in XAML, like so:

xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"
xmlns:ei="http://schemas.microsoft.com/expression/2010/interactions"

VERSION 4 UPDATE: The toolkit has been split into two assemblies:

SimpleMvvmToolkit-Common
SimpleMvvmToolkit-WPF

WPF version 4.5 and later is supported for this release.
In addition you need to reference System.Windows, which has ICommand support.
One breaking change is that IsInDesignMode is now defined as an extension method,
therefore you need to call it like so: this.IsInDesignMode()
