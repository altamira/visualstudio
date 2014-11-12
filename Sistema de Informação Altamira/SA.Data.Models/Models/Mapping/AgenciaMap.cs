using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.Data.Models.Mapping
{
    public class AgenciaMap : EntityTypeConfiguration<SA.Data.Models.Agencia>
    {
        public AgenciaMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Numero)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(10);

            this.Property(t => t.Gerente)
                .HasMaxLength(50);

            this.Property(t => t.Telefone)
                .IsFixedLength()
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("Agencia", "Financeiro");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Banco).HasColumnName("Banco");
            this.Property(t => t.Numero).HasColumnName("Numero");
            this.Property(t => t.Gerente).HasColumnName("Gerente");
            this.Property(t => t.Telefone).HasColumnName("Telefone");

            // Relationships
            this.HasRequired(t => t.Banco1)
                .WithMany(t => t.Agencias)
                .HasForeignKey(d => d.Banco);

        }
    }
}
