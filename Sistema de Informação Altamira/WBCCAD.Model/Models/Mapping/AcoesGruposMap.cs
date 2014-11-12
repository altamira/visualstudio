using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class AcoesGruposMap : EntityTypeConfiguration<AcoesGrupos>
    {
        public AcoesGruposMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idAcaoGrupo, t.idAcao, t.idGrupo });

            // Properties
            this.Property(t => t.idAcaoGrupo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.idAcao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idGrupo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("AcoesGrupos");
            this.Property(t => t.idAcaoGrupo).HasColumnName("idAcaoGrupo");
            this.Property(t => t.idAcao).HasColumnName("idAcao");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
        }
    }
}
