using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class GruposMap : EntityTypeConfiguration<Grupos>
    {
        public GruposMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idGrupo, t.idNivel, t.Grupo });

            // Properties
            this.Property(t => t.idGrupo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.idNivel)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.Grupo)
                .IsRequired()
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("Grupos");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
            this.Property(t => t.idNivel).HasColumnName("idNivel");
            this.Property(t => t.Grupo).HasColumnName("Grupo");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativo).HasColumnName("Ativo");
        }
    }
}
