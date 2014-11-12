using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class idmdtcMap : EntityTypeConfiguration<idmdtc>
    {
        public idmdtcMap()
        {
            // Primary Key
            this.HasKey(t => t.idIdmDtc);

            // Properties
            this.Property(t => t.idioma)
                .HasMaxLength(20);

            this.Property(t => t.dtc_codigo)
                .HasMaxLength(20);

            this.Property(t => t.dtc_bmp)
                .HasMaxLength(40);

            this.Property(t => t.dtc_inicial)
                .HasMaxLength(7);

            // Table & Column Mappings
            this.ToTable("idmdtc");
            this.Property(t => t.idioma).HasColumnName("idioma");
            this.Property(t => t.dtc_codigo).HasColumnName("dtc_codigo");
            this.Property(t => t.dtc_bmp).HasColumnName("dtc_bmp");
            this.Property(t => t.dtc_linha).HasColumnName("dtc_linha");
            this.Property(t => t.dtc_inicial).HasColumnName("dtc_inicial");
            this.Property(t => t.dtc_qtde_linhas).HasColumnName("dtc_qtde_linhas");
            this.Property(t => t.idIdmDtc).HasColumnName("idIdmDtc");
        }
    }
}
