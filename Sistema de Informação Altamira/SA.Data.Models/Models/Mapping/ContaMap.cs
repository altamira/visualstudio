using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.Data.Models.Mapping
{
    public class ContaMap : EntityTypeConfiguration<SA.Data.Models.Conta>
    {
        public ContaMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Numero)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(10);

            // Properties
            this.Property(t => t.Saldo);

            // Table & Column Mappings
            this.ToTable("Conta", "Financeiro");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Agencia).HasColumnName("Agencia");
            this.Property(t => t.Numero).HasColumnName("Numero");
            this.Property(t => t.Saldo).HasColumnName("Saldo");

            // Relationships
            this.HasRequired(t => t.Agencia1)
                .WithMany(t => t.Contas)
                .HasForeignKey(d => d.Agencia);

        }
    }
}
