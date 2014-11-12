using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using WpfApplication3.Models.Mapping;

namespace WpfApplication3.Models
{
    public partial class DBContext : DbContext
    {
        static DBContext()
        {
            Database.SetInitializer<DBContext>(null);
        }

        public DBContext()
            : base("Name=AVALIACAOContext")
        {
        }

        public DbSet<CLIENTE> CLIENTES { get; set; }
        public DbSet<PEDIDO> PEDIDOS { get; set; }
        public DbSet<SITUACAO> SITUACOES { get; set; }
        public DbSet<SITUACAO_PEDIDO> SITUACAO_PEDIDOS { get; set; }
        public DbSet<VIEW_SITUACAO_PEDIDO> VIEW_SITUACAO_PEDIDOS { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new CLIENTEMap());
            modelBuilder.Configurations.Add(new PEDIDOMap());
            modelBuilder.Configurations.Add(new SITUACAOMap());
            modelBuilder.Configurations.Add(new SITUACAO_PEDIDOMap());
            modelBuilder.Configurations.Add(new VIEW_SITUACAO_PEDIDOMap());
        }
    }
}
