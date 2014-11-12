using System.Windows.Controls;
using System.Windows;
using System.Collections;

namespace GestaoApp.Controls
{
    public partial class SearchListView : UserControl
    {
        public SearchListView()
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

        public static readonly DependencyProperty SelectionModeProperty = DependencyProperty.Register("SelectionMode", typeof(SelectionMode), typeof(SearchListView), new PropertyMetadata(new PropertyChangedCallback(OnSelectionModeChanged)));

        protected static void OnSelectionModeChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchListView view = element as SearchListView;
            /*if (view != null)
                if (e.NewValue != null)
                    view.SelectListBox.SelectionMode = (SelectionMode)e.NewValue;*/
        }

        #endregion

        /*#region SelectedItem Property
        public string SelectedItem
        {
            get { return (string)GetValue(SelectedItemProperty); }
            set 
            { 
                SetValue(SelectedItemProperty, value);
                this.SelectListBox.SelectedItem = value;
            }
        }

        public static readonly DependencyProperty SelectedItemProperty = DependencyProperty.Register("SelectedItem", typeof(object), typeof(SearchListView), new PropertyMetadata(new PropertyChangedCallback(OnSelectedItemChanged)));

        protected static void OnSelectedItemChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchListView view = element as SearchListView;
            if (view != null)
                if (e.NewValue != null)
                    view.SelectListBox.SelectedItem = (object)e.NewValue;
        }

        #endregion*/

        #region Title Property
        public string Title
        {
            get { return (string)GetValue(TitleProperty); }
            set { SetValue(TitleProperty, value); }
        }

        public static readonly DependencyProperty TitleProperty = DependencyProperty.Register("Title", typeof(string), typeof(SearchListView), new PropertyMetadata(new PropertyChangedCallback(OnTitleChanged)));

        protected static void OnTitleChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {
            SearchListView view = element as SearchListView;
            if (view != null)
                view.TitleTextBox.Text = (e.NewValue as string);
        }

        #endregion

        #region ItemsSource Property

        public static DependencyProperty ItemsSourceProperty =
            DependencyProperty.Register("ItemsSource", typeof(IEnumerable), typeof(SearchListView), new PropertyMetadata(ItemsSourceChanged)); 

        private static void ItemsSourceChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e) 
        {
            SearchListView view = sender as SearchListView; 
            
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
            this.SelectListBox.ItemsSource = null;
        }

        private void BindItems(IEnumerable items)
        {
            this.SelectListBox.Items.Clear();
            this.SelectListBox.ItemsSource = items;
        }
        #endregion

        #region ItemTemplate Property
        public DataTemplate ItemTemplate
        {
            get { return (DataTemplate)GetValue(ItemTemplateProperty); }
            set { SetValue(ItemTemplateProperty, value); }
        }

        public static readonly DependencyProperty ItemTemplateProperty = DependencyProperty.Register("ItemTemplate", typeof(DataTemplate), typeof(SearchListView), new PropertyMetadata(new PropertyChangedCallback(OnItemTemplateChanged)));

        protected static void OnItemTemplateChanged(DependencyObject element, DependencyPropertyChangedEventArgs e)
        {

            SearchListView view = element as SearchListView;
            if (view != null)
                view.ApplyItemTemplate(e.NewValue as DataTemplate);
        }

        protected void ApplyItemTemplate(DataTemplate template)
        {
            this.SelectListBox.ItemTemplate = template;
        }
        #endregion  

        private void DoubleClickHandler(object sender, RoutedEventArgs e)
        {

        }

    }

}
