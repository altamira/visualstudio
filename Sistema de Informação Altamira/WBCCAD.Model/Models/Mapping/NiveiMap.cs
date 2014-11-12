using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class NiveiMap : EntityTypeConfiguration<Nivei>
    {
        public NiveiMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idNivel, t.Nivel });

            // Properties
            this.Property(t => t.idNivel)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.Nivel)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.Descricao)
                .HasMaxLength(255);

            this.Property(t => t.Observacoes)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Niveis");
            this.Property(t => t.idNivel).HasColumnName("idNivel");
            this.Property(t => t.Nivel).HasColumnName("Nivel");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
        }
    }
}
