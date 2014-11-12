using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.Data.Models.Mapping
{
    public class BancoMap : EntityTypeConfiguration<SA.Data.Models.Banco>
    {
        public BancoMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Nome)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("Banco", "Financeiro");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Numero).HasColumnName("Numero");
            this.Property(t => t.Nome).HasColumnName("Nome");
        }
    }
}
