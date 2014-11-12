using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_dtcMap : EntityTypeConfiguration<gen_dtc>
    {
        public gen_dtcMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.dtc_codigo)
                .HasMaxLength(20);

            this.Property(t => t.dtc_bmp)
                .HasMaxLength(40);

            this.Property(t => t.dtc_inicial)
                .HasMaxLength(7);

            this.Property(t => t.dtcrtf)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_dtc");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.dtc_codigo).HasColumnName("dtc_codigo");
            this.Property(t => t.dtc_bmp).HasColumnName("dtc_bmp");
            this.Property(t => t.dtc_linha).HasColumnName("dtc_linha");
            this.Property(t => t.dtc_inicial).HasColumnName("dtc_inicial");
            this.Property(t => t.dtc_qtde_linhas).HasColumnName("dtc_qtde_linhas");
            this.Property(t => t.dtcrtf).HasColumnName("dtcrtf");
            this.Property(t => t.GEN_DTC_ALT).HasColumnName("GEN_DTC_ALT");
            this.Property(t => t.GEN_DTC_LRG).HasColumnName("GEN_DTC_LRG");
        }
    }
}
