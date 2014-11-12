using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_comprMap : EntityTypeConfiguration<gond_cjtos_compr>
    {
        public gond_cjtos_comprMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtosCompr);

            // Properties
            this.Property(t => t.descricao_cjto)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_compr");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.idGondCjtosCompr).HasColumnName("idGondCjtosCompr");
        }
    }
}
