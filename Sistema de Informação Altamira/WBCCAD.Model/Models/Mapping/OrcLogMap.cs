using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcLogMap : EntityTypeConfiguration<OrcLog>
    {
        public OrcLogMap()
        {
            // Primary Key
            this.HasKey(t => t.orclog_nr_seq);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.orclog_usuario)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcLog");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.orclog_data).HasColumnName("orclog_data");
            this.Property(t => t.orclog_time).HasColumnName("orclog_time");
            this.Property(t => t.orclog_usuario).HasColumnName("orclog_usuario");
            this.Property(t => t.orclog_nr_seq).HasColumnName("orclog_nr_seq");
            this.Property(t => t.orclog_linha).HasColumnName("orclog_linha");
        }
    }
}
