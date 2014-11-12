using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using SA.Data.Models.Mapping;

namespace SA.Data.Models
{
    public partial class SAContext : DbContext
    {
        static SAContext()
        {
            Database.SetInitializer<SAContext>(null);
        }

        public SAContext()
            : base("Name=SAContext")
        {
        }

        public DbSet<SA.Data.Models.Agencia> Agencias { get; set; }
        public DbSet<SA.Data.Models.Banco> Bancos { get; set; }
        public DbSet<SA.Data.Models.Conta> Contas { get; set; }
        public DbSet<SA.Data.Models.Movimento> Movimentos { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new AgenciaMap());
            modelBuilder.Configurations.Add(new BancoMap());
            modelBuilder.Configurations.Add(new ContaMap());
            modelBuilder.Configurations.Add(new MovimentoMap());
        }
    }
}
