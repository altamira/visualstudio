using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_rel_grp_acab_corMap : EntityTypeConfiguration<gen_rel_grp_acab_cor>
    {
        public gen_rel_grp_acab_corMap()
        {
            // Primary Key
            this.HasKey(t => t.idordem);

            // Properties
            this.Property(t => t.nome_grupo)
                .HasMaxLength(50);

            this.Property(t => t.nome_cor)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_rel_grp_acab_cor");
            this.Property(t => t.nome_grupo).HasColumnName("nome_grupo");
            this.Property(t => t.nome_cor).HasColumnName("nome_cor");
            this.Property(t => t.idordem).HasColumnName("idordem");
        }
    }
}
