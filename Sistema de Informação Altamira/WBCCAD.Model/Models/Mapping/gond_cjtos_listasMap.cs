using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_listasMap : EntityTypeConfiguration<gond_cjtos_listas>
    {
        public gond_cjtos_listasMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtosListas);

            // Properties
            this.Property(t => t.descricao_cjto)
                .HasMaxLength(100);

            this.Property(t => t.descricao_lista)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_listas");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.descricao_lista).HasColumnName("descricao_lista");
            this.Property(t => t.idGondCjtosListas).HasColumnName("idGondCjtosListas");
        }
    }
}
