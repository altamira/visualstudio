using System;
using System.Linq;
using GestaoApp.View;
using GestaoApp.Models.Location;
using GestaoApp.Models.Contact;
using GestaoApp.View.Contact;

namespace GestaoApp.ViewModel.Contact
{
    public class FoneViewModel : SearchViewModel<Fone>
    {
        #region Attributes

        #endregion

        #region Properties

        public override Fone SelectedItem
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
            FoneFormView childWindow = new FoneFormView();
            childWindow.DataContext = new Fone();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is FoneFormView)
                if ((sender as FoneFormView).DataContext is Fone)
                {
                    SearchResultList.Add((sender as FoneFormView).DataContext as Fone);
                    SelectedItem = (sender as FoneFormView).DataContext as Fone;
                }
        }

        public override void Edit(object parameter)
        {
            FoneFormView childWindow = new FoneFormView();
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
                SearchResultList.Insert(i, ((sender as FoneFormView).DataContext) as Fone);
            }
            else
                SearchResultList.Add(((sender as FoneFormView).DataContext) as Fone);

            SelectedItem = ((sender as FoneFormView).DataContext) as Fone;
        }

        #endregion

    }
}
