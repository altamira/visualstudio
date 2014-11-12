using System.Windows.Controls;
using System.Windows;
using System.Collections;
using Telerik.Windows.Controls;

namespace GestaoApp.Controls
{
    public partial class SearchGridView : UserControl
    {
        public SearchGridView()
        {
            InitializeComponent();
        }

        private void TextBox_UpdateBinding(object sender, TextChangedEventArgs e)
        {
            var binding = ((TextBox)sender).GetBindingExpression(TextBox.TextProperty);
            binding.UpdateSource();
        }

        #region SelectionMode Property
        public string SelectionMode
        {
            get { return (string)GetValue(SelectionModeProperty); }
            set { SetValue(SelectionModeProperty, value); }
        }

        public static readonly DependencyProperty SelectionModeProperty = DependencyProperty.Register("SelectionMode", typeof(System.Windows.Controls.SelectionMode), typeof(SearchGridView), new PropertyMetadata(new PropertyChangedCallback(OnSelectionModeChanged)));

        protected static void OnSelectionModeChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchGridView view = element as SearchGridView;
            //if (view != null)
                //if (e.NewValue != null)
                    //view.SelectListBox.SelectionMode = (SelectionMode)e.NewValue;
        }

        #endregion

        /*#region SelectedItem Property
        public string SelectedItem
        {
            get { return (string)GetValue(SelectedItemProperty); }
            set { SetValue(SelectedItemProperty, value); }
        }

        public static readonly DependencyProperty SelectedItemProperty = DependencyProperty.Register("SelectedItem", typeof(object), typeof(SearchListView), new PropertyMetadata(new PropertyChangedCallback(OnSelectedItemChanged)));

        protected static void OnSelectedItemChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchGridView view = element as SearchGridView;
            if (view != null)
                if (e.NewValue != null)
                    view.SelectGrid.SelectedItem = (object)e.NewValue;
        }

        #endregion*/

        #region Title Property
        public string Title
        {
            get { return (string)GetValue(TitleProperty); }
            set 
            { 
                SetValue(TitleProperty, value);
                TitleTextBox.Text = value;
            }
        }

        public static readonly DependencyProperty TitleProperty = DependencyProperty.Register("Title", typeof(string), typeof(SearchGridView), new PropertyMetadata(new PropertyChangedCallback(OnTitleChanged)));

        protected static void OnTitleChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchGridView view = element as SearchGridView;
            /*if (view != null)
                view.TitleTextBox.Text = (e.NewValue as string);*/
        }

        #endregion

        #region ItemSource Property
        public static DependencyProperty ItemsSourceProperty =
            DependencyProperty.Register("ItemsSource", typeof(IEnumerable), typeof(SearchGridView), new PropertyMetadata(ItemsSourceChanged));

        private static void ItemsSourceChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e)
        {
            SearchGridView view = sender as SearchGridView;

            if (view == null)
                return;

            view.OnItemsSourceChanged(e);
        }

        protected virtual void OnItemsSourceChanged(DependencyPropertyChangedEventArgs e)
        {
            if (e.OldValue != null)
            {
                ClearItems();
            }

            if (e.NewValue != null)
            {
                BindItems((IEnumerable)e.NewValue);
            }
        }

        public IEnumerable ItemsSource
        {
            get { return (IEnumerable)GetValue(ItemsSourceProperty); }
            set { SetValue(ItemsSourceProperty, value); }
        }

        private void ClearItems()
        {
            this.SelectGrid.ItemsSource = null;
        }

        private void BindItems(IEnumerable items)
        {
            this.SelectGrid.Items.Clear();
            this.SelectGrid.ItemsSource = items;
        }
        #endregion

        #region ItemTemplate Property
        public DataTemplate ItemTemplate
        {
            get { return (DataTemplate)GetValue(ItemTemplateProperty); }
            set { SetValue(ItemTemplateProperty, value); }
        }

        public static readonly DependencyProperty ItemTemplateProperty = DependencyProperty.Register("ItemTemplate", typeof(DataTemplate), typeof(SearchGridView), new PropertyMetadata(new PropertyChangedCallback(OnItemTemplateChanged)));

        protected static void OnItemTemplateChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchGridView view = element as SearchGridView;
            if (view != null)
                view.ApplyItemTemplate(e.NewValue as DataTemplate);
        }

        protected void ApplyItemTemplate(DataTemplate template)
        {
            this.SelectGrid.ItemTemplate = template;
        }
        #endregion
    }

}
