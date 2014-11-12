using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_rel_eqpto_grp_acabMap : EntityTypeConfiguration<gen_rel_eqpto_grp_acab>
    {
        public gen_rel_eqpto_grp_acabMap()
        {
            // Primary Key
            this.HasKey(t => t.idordem);

            // Properties
            this.Property(t => t.nome_grupo)
                .HasMaxLength(50);

            this.Property(t => t.nome_eqpto)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_rel_eqpto_grp_acab");
            this.Property(t => t.nome_grupo).HasColumnName("nome_grupo");
            this.Property(t => t.nome_eqpto).HasColumnName("nome_eqpto");
            this.Property(t => t.idordem).HasColumnName("idordem");
        }
    }
}
