using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;

namespace GestaoApp.Helpers
{
    public class FilterAsyncParameters
    {
		public Action FilterComplete
		{
			get;
			private set;
		}

		public string FilterCriteria
		{
			get;
			private set;
		}

		public FilterAsyncParameters(Action filterComplete, string filterCriteria)
		{
			FilterComplete = filterComplete;
			FilterCriteria = filterCriteria;
		}
    }
}
