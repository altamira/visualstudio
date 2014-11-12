using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using SA.WPF.Financial.Model.Mapping;
using System.Linq;
using System.Collections.Generic;
using SA.WPF.Financial.Model.Filters;

namespace SA.WPF.Financial.Model
{
    public partial class Context : DbContext
    {
        static Context()
        {
            Database.SetInitializer<Context>(null);
        }

        public Context()
            : base("Name=ContextConnectionString")
        {
        }

        public DbSet<Agency> Agencies { get; set; }
        public DbSet<Bank> Bank { get; set; }
        public DbSet<Account> Accounts { get; set; }
        public IDbSet<Transaction> Transactions { get; set; }

        /// <summary>
        /// Applies globally the filter.
        /// </summary>
        /// <param name="filters"></param>
        public void ApplyFilters(IList<IFilter<Context>> filters)
        {
            foreach (var filter in filters)
            {
                filter.DbContext = this;
                filter.Apply();
            }
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new AgencyMap());
            modelBuilder.Configurations.Add(new BankMap());
            modelBuilder.Configurations.Add(new AccountMap());
            modelBuilder.Configurations.Add(new TransactionMap());
        }

        public int SaveChanges(Account Account)
        {
            foreach (Transaction m in ChangeTracker.Entries<Transaction>().Where(
                            entity => entity.State == EntityState.Added && entity.Entity.Account == null).Select(x => x.Entity))
            {
                m.Account = Account;
            }

            return base.SaveChanges();
        }
    }
}
