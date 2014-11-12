using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.WPF.Financial.Model.Wrapper
{
    class TransactionCollection : ObservableCollection<Transaction>
    {
        private Context context;

        public TransactionCollection(Context context)
        {
            this.context = context;
        }

        //private Account AccountSelectedItem;

        public Account AccountSelectedItem { get; set; }

        protected override void InsertItem(int index, Transaction item)
        {
            item.Account = AccountSelectedItem;
            context.Transactions.Add(item);
            base.InsertItem(index, item);
        }

        protected override void RemoveItem(int index)
        {
            context.Transactions.Remove(this.Items[index]);
            base.RemoveItem(index);
        }

        protected override void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            base.OnCollectionChanged(e);
        }
    }
}
