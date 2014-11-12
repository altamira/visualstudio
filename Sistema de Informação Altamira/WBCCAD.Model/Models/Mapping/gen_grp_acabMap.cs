using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_grp_acabMap : EntityTypeConfiguration<gen_grp_acab>
    {
        public gen_grp_acabMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.nome)
                .HasMaxLength(50);

            this.Property(t => t.sigla_grupo)
                .HasMaxLength(10);

            this.Property(t => t.COR_PADRAO)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_grp_acab");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.nome).HasColumnName("nome");
            this.Property(t => t.sigla_grupo).HasColumnName("sigla_grupo");
            this.Property(t => t.COR_PADRAO).HasColumnName("COR_PADRAO");
        }
    }
}
