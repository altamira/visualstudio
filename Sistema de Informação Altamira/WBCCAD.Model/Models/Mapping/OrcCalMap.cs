using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcCalMap : EntityTypeConfiguration<OrcCal>
    {
        public OrcCalMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcCal);

            // Properties
            this.Property(t => t.orccal_tipo_calculo)
                .HasMaxLength(30);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcCal");
            this.Property(t => t.idOrcCal).HasColumnName("idOrcCal");
            this.Property(t => t.orccal_fator).HasColumnName("orccal_fator");
            this.Property(t => t.orccal_grupo).HasColumnName("orccal_grupo");
            this.Property(t => t.orccal_nr_vezes).HasColumnName("orccal_nr_vezes");
            this.Property(t => t.orccal_tipo_calculo).HasColumnName("orccal_tipo_calculo");
            this.Property(t => t.orccal_valor).HasColumnName("orccal_valor");
            this.Property(t => t.ORCCALTOTALLISTA).HasColumnName("ORCCALTOTALLISTA");
            this.Property(t => t.ORCCALTOTALVENDA).HasColumnName("ORCCALTOTALVENDA");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
