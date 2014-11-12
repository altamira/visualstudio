using System;
using System.Collections.ObjectModel;
using GestaoApp.Models;
using GestaoApp.View;
using GestaoApp.Models.Contact;
using GestaoApp.View.Contact;

namespace GestaoApp.ViewModel.Contact
{
    public class PersonViewModel : SearchViewModel<Person>
    {
        #region Attributes

        private FoneViewModel foneviewmodel = new FoneViewModel();

        private EmailViewModel emailviewmodel = new EmailViewModel();

        #endregion

        #region Properties

        public override Person SelectedItem
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

                    if (selectedItem != null)
                    {
                        FoneViewModel.SearchResultList = SelectedItem.ContactFone;
                        EmailViewModel.SearchResultList = SelectedItem.ContactEmail;
                    }
                    else
                    {
                        FoneViewModel.SearchResultList = null;
                        EmailViewModel.SearchResultList = null;
                    }

                    FoneViewModel.SelectedItem = null;
                    EmailViewModel.SelectedItem = null;

                    if (value != null)
                    {
                        this.CanEdit = true;
                        //this.CanDelete = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        //this.CanDelete = false;
                    }

                }
            }
        }

        public override ObservableCollection<Person> SearchResultList
        {
            get
            {
                return searchResultList;
            }
            set
            {
                if ((object.ReferenceEquals(this.searchResultList, value) != true))
                {
                    searchResultList = value;
                    SelectedItem = null;

                    FoneViewModel.SearchResultList = null;
                    EmailViewModel.SearchResultList = null;

                    if (value == null)
                        this.CanAdd = false;
                    else
                        this.CanAdd = true;

                    this.CanEdit = false;
                    this.CanDelete = false;

                    OnPropertyChanged("SearchResultList");
                }
            }
        }

        public FoneViewModel FoneViewModel
        {
            get
            {
                return foneviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.foneviewmodel, value) != true))
                {
                    foneviewmodel = value;
                    this.OnPropertyChanged("FoneViewModel");
                }
            }
        }

        public EmailViewModel EmailViewModel
        {
            get
            {
                return emailviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.emailviewmodel, value) != true))
                {
                    emailviewmodel = value;
                    this.OnPropertyChanged("EmailViewModel");
                }
            }
        }

        #endregion

        #region Commands

        public override void Add(object parameter)
        {
            PersonFormView childWindow = new PersonFormView();
            childWindow.DataContext = new Person();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is PersonFormView)
                if ((sender as PersonFormView).DataContext is Person)
                {
                    SearchResultList.Add((sender as PersonFormView).DataContext as Person);
                    SelectedItem = (sender as PersonFormView).DataContext as Person;
                }
        }

        public override void Edit(object parameter)
        {
            PersonFormView childWindow = new PersonFormView();
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
                SearchResultList.Insert(i, ((sender as PersonFormView).DataContext) as Person);
            }
            else
                SearchResultList.Add(((sender as PersonFormView).DataContext) as Person);

            SelectedItem = ((sender as PersonFormView).DataContext) as Person;
        }
        #endregion
    }
}
