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
using GestaoApp.View;
using GestaoApp.Models.Contact;
using GestaoApp.View.Contact;

namespace GestaoApp.ViewModel.Contact
{
    public class EmailViewModel : SearchViewModel<Email>
    {
        #region Attributes

        #endregion

        #region Properties

        public override Email SelectedItem
        {
            get
            {
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    selectedItem = value;
                    OnPropertyChanged("SelectedItem");

                    if (value != null)
                    {
                        this.CanEdit = true;
                        this.CanDelete = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        this.CanDelete = false;
                    }

                }
            }
        }
        #endregion

        #region Commands

        public override void Add(object parameter)
        {
            EmailFormView childWindow = new EmailFormView();
            childWindow.DataContext = new Email();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is EmailFormView)
                if ((sender as EmailFormView).DataContext is Email)
                {
                    SearchResultList.Add((sender as EmailFormView).DataContext as Email);
                    SelectedItem = (sender as EmailFormView).DataContext as Email;
                }
        }

        public override void Edit(object parameter)
        {
            EmailFormView childWindow = new EmailFormView();
            childWindow.DataContext = SelectedItem.Clone();
            childWindow.OnSave = new EventHandler(OnEditComplete);
            childWindow.Show();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            int i = SearchResultList.IndexOf(SelectedItem);
            if (i >= 0)
            {
                SearchResultList.RemoveAt(i);
                SearchResultList.Insert(i, ((sender as EmailFormView).DataContext) as Email);
            }
            else
                SearchResultList.Add(((sender as EmailFormView).DataContext) as Email);

            SelectedItem = ((sender as EmailFormView).DataContext) as Email;
        }

        #endregion
    }
}
