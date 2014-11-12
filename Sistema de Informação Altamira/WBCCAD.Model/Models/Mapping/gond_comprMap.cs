using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_comprMap : EntityTypeConfiguration<gond_compr>
    {
        public gond_comprMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCompr);

            // Properties
            this.Property(t => t.grafia)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_compr");
            this.Property(t => t.Comprimento).HasColumnName("Comprimento");
            this.Property(t => t.grafia).HasColumnName("grafia");
            this.Property(t => t.vale_para_edicao).HasColumnName("vale_para_edicao");
            this.Property(t => t.idGondCompr).HasColumnName("idGondCompr");
        }
    }
}
