using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_cadastro_caracteristicas_siglaMap : EntityTypeConfiguration<mob_cadastro_caracteristicas_sigla>
    {
        public mob_cadastro_caracteristicas_siglaMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobCadastroCaracteristicasSigla);

            // Properties
            this.Property(t => t.caracteristica)
                .HasMaxLength(50);

            this.Property(t => t.sigla)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("mob_cadastro_caracteristicas_sigla");
            this.Property(t => t.caracteristica).HasColumnName("caracteristica");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.idMobCadastroCaracteristicasSigla).HasColumnName("idMobCadastroCaracteristicasSigla");
        }
    }
}
