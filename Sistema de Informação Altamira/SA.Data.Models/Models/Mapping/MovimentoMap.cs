using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.Data.Models.Mapping
{
    public class MovimentoMap : EntityTypeConfiguration<SA.Data.Models.Movimento>
    {
        public MovimentoMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.Operacao)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Movimento", "Financeiro");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Conta).HasColumnName("Conta");
            this.Property(t => t.Data).HasColumnName("Data");
            this.Property(t => t.Cheque).HasColumnName("Cheque");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.Valor).HasColumnName("Valor");
            this.Property(t => t.Operacao).HasColumnName("Operacao");
            this.Property(t => t.Liquidado).HasColumnName("Liquidado");

            // Relationships
            this.HasRequired(t => t.Conta1)
                .WithMany(t => t.Movimentos)
                .HasForeignKey(d => d.Conta);

        }
    }
}
