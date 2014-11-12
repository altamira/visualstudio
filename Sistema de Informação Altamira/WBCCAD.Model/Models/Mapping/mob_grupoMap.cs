using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_grupoMap : EntityTypeConfiguration<mob_grupo>
    {
        public mob_grupoMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobGrupo);

            // Properties
            this.Property(t => t.Descricao)
                .HasMaxLength(255);

            this.Property(t => t.observacoes)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("mob_grupo");
            this.Property(t => t.idMobGrupo).HasColumnName("idMobGrupo");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.observacoes).HasColumnName("observacoes");
        }
    }
}
