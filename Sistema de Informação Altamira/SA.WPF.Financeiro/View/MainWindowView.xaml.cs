using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Ribbon;
using System.Windows.Input;
using System.Windows.Media;
using System.Data.Entity;
using System.Collections.ObjectModel;
using System.Data;
using SA.WPF.Financial.Model;
using GalaSoft.MvvmLight.Messaging;

namespace SA.WPF.Financial.View
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindowView : RibbonWindow
    {
        Context context = new Context();

        public MainWindowView()
        {
            InitializeComponent();

            Messenger.Default.Register<NotificationMessage>(this, NotificationMessageView.TransactionViewShow);
        }

        //private void RibbonWindow_Loaded(object sender, RoutedEventArgs e)
        //{
        //    System.Windows.Data.CollectionViewSource TransactionViewSource =
        //        ((System.Windows.Data.CollectionViewSource)(this.FindResource("TransactionViewSource")));

        //    System.Windows.Data.CollectionViewSource BankViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("BankViewSource")));

        //    try
        //    {
        //        context.Bank.Include("Agencies.Accounts").Load();
        //        BankViewSource.Source = context.Bank.Local;
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show(ex.Message);
        //    }
        //}

        //private void Gravar_Click(object sender, RoutedEventArgs e)
        //{
        //    Gravar();
           
        //}

        //private void Gravar()
        //{
        //    try
        //    {
        //        context.SaveChanges();

        //        MessageBox.Show("Dados alterados/incluidos com sucesso!");
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show("Erro ao atualizar/incluir os dados, entre em Accountto com a área de sistemas.\n ERRO:" + ex.Message);
        //    }
        //}

        //private void DataGridCell_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        //{
        //    DataGridCell cell = sender as DataGridCell;

        //    if (cell != null && !cell.IsEditing && !cell.IsReadOnly)
        //    {
        //        if (!cell.IsFocused)
        //        {
        //            cell.Focus();
        //        }
        //        DataGrid dataGrid = FindVisualParent<DataGrid>(cell);

        //        if (dataGrid != null)
        //        {
        //            if (dataGrid.SelectionUnit != DataGridSelectionUnit.FullRow)
        //            {
        //                if (!cell.IsSelected)
        //                    cell.IsSelected = true;
        //            }
        //            else
        //            {
        //                DataGridRow row = FindVisualParent<DataGridRow>(cell);
        //                if (row != null && !row.IsSelected)
        //                {
        //                    row.IsSelected = true;
        //                }
        //            }
        //        }
        //    }
        //}

        //static T FindVisualParent<T>(UIElement element) where T : UIElement
        //{
        //    UIElement parent = element;
        //    while (parent != null)
        //    {
        //        T correctlyTyped = parent as T;
        //        if (correctlyTyped != null)
        //        {
        //            return correctlyTyped;
        //        }

        //        parent = VisualTreeHelper.GetParent(parent) as UIElement;
        //    }
        //    return null;
        //}

    }
}
