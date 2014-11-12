using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.ViewModel.Bid;

namespace GestaoApp.View.Bid
{
    public partial class DocumentView : ChildWindow
    {
        public EventHandler OnSelect;

        public DocumentView()
        {
            InitializeComponent();
        }

        private void SelectButton_Click(object sender, RoutedEventArgs e)
        {
            if (OnSelect != null && (this.DataContext as DocumentViewModel) != null)
                if ((this.DataContext as DocumentViewModel).SelectedItem != null)
                    OnSelect((this.DataContext as DocumentViewModel).SelectedItem, new EventArgs());

            this.DialogResult = true;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }
    }
}

