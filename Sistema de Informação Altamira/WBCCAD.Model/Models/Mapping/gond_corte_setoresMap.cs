using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_setoresMap : EntityTypeConfiguration<gond_corte_setores>
    {
        public gond_corte_setoresMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteSetores);

            // Properties
            this.Property(t => t.setor)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_setores");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.setor).HasColumnName("setor");
            this.Property(t => t.idGondCorteSetores).HasColumnName("idGondCorteSetores");
        }
    }
}
