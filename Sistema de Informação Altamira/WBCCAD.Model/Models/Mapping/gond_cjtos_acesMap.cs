using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_acesMap : EntityTypeConfiguration<gond_cjtos_aces>
    {
        public gond_cjtos_acesMap()
        {
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.descricao_cjto)
                .HasMaxLength(50);

            this.Property(t => t.descricao_aces)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_aces");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.descricao_aces).HasColumnName("descricao_aces");
            this.Property(t => t.ID).HasColumnName("ID");
        }
    }
}
