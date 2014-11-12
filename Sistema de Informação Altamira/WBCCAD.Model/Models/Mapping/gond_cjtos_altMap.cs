using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_altMap : EntityTypeConfiguration<gond_cjtos_alt>
    {
        public gond_cjtos_altMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtosAlt);

            // Properties
            this.Property(t => t.altura)
                .HasMaxLength(50);

            this.Property(t => t.descricao_cjto)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_alt");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.e_padrao).HasColumnName("e_padrao");
            this.Property(t => t.idGondCjtosAlt).HasColumnName("idGondCjtosAlt");
        }
    }
}
