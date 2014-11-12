using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PeslogMap : EntityTypeConfiguration<Peslog>
    {
        public PeslogMap()
        {
            // Primary Key
            this.HasKey(t => t.peslog_nr_seq);

            // Properties
            this.Property(t => t.peslog_nr_seq)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.peslog_tipo)
                .HasMaxLength(6);

            this.Property(t => t.peslog_obs)
                .HasMaxLength(255);

            this.Property(t => t.peslog_usuario)
                .HasMaxLength(12);

            // Table & Column Mappings
            this.ToTable("Peslog");
            this.Property(t => t.peslog_codigo).HasColumnName("peslog_codigo");
            this.Property(t => t.peslog_nr_seq).HasColumnName("peslog_nr_seq");
            this.Property(t => t.peslog_tipo).HasColumnName("peslog_tipo");
            this.Property(t => t.peslog_data).HasColumnName("peslog_data");
            this.Property(t => t.peslog_obs).HasColumnName("peslog_obs");
            this.Property(t => t.peslog_usuario).HasColumnName("peslog_usuario");
        }
    }
}
