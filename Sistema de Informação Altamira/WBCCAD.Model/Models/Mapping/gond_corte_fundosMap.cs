using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_fundosMap : EntityTypeConfiguration<gond_corte_fundos>
    {
        public gond_corte_fundosMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteFundos);

            // Properties
            this.Property(t => t.fundo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_fundos");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.fundo).HasColumnName("fundo");
            this.Property(t => t.id_fundo).HasColumnName("id_fundo");
            this.Property(t => t.idGondCorteFundos).HasColumnName("idGondCorteFundos");
        }
    }
}
