using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using DAL.Models.Mapping;
using Model;

namespace DAL.Models
{
    public partial class NFeDbContext : DbContext
    {
        static NFeDbContext()
        {
            Database.SetInitializer<NFeDbContext>(null);
        }

        public NFeDbContext()
            : base("Name=ConnectionString")
        {
        }

        public DbSet<Message> Messages { get; set; }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<Invoice_Fetch_Error_Message> Invoice_Fetch_Error_Message { get; set; }
        public DbSet<Invoice_Fetch_Error_Message_Part> Invoice_Fetch_Error_Message_Part { get; set; }
        public DbSet<Invoice_Fetch_Log> Invoice_Fetch_Log { get; set; }
        public DbSet<Parameter> Parameters { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new MessageMap());
            modelBuilder.Configurations.Add(new InvoiceMap());
            modelBuilder.Configurations.Add(new Invoice_Fetch_Error_MessageMap());
            modelBuilder.Configurations.Add(new Invoice_Fetch_Error_Message_PartMap());
            modelBuilder.Configurations.Add(new Invoice_Fetch_LogMap());
            modelBuilder.Configurations.Add(new ParameterMap());
        }
    }
}
