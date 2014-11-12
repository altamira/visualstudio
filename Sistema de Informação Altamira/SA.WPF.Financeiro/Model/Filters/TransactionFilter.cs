using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Model.Filters
{
    public class TransactionFilter : IFilter<Context>
    {
        public SA.WPF.Financial.Model.Context DbContext { get; set; }

        public Account Account { get; set; }
        public LIQUIDATED liquidated { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public TransactionFilter(Account Account, LIQUIDATED Liquidated, DateTime? StartDate, DateTime? EndDate)
        {
            this.Account = Account != null ? Account : new Account();
            this.Liquidated = Liquidated != null ? Liquidated : LIQUIDATED.NO;
            this.StartDate = StartDate;
            this.EndDate = EndDate;
        }

        public void Apply()
        {
            bool i = Convert.ToBoolean(Liquidated);

            DbContext.Transactions = new FilteredDbSet<Transaction>(DbContext, m => m.Account.Id == this.Account.Id
                                                                && (Liquidated == Liquidated.ALL || m.Liquidated == i)
                                                                && ((!StartDate.HasValue || !EndDate.HasValue) || (m.Data >= StartDate && m.Data <= EndDate)));
            //DbContext.Transactions = new FilteredDbSet2<Transaction>(DbContext, m => !m.liquidated);
        }
    }
}
