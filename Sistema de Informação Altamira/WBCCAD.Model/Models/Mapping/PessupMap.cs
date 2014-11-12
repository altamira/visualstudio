using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PessupMap : EntityTypeConfiguration<Pessup>
    {
        public PessupMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pessup_codigo, t.pessup_comis_flag, t.pessup_desabilitado, t.idPessup });

            // Properties
            this.Property(t => t.pessup_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.pessup_comis_tipo)
                .HasMaxLength(20);

            this.Property(t => t.PESSUP_CARGO)
                .HasMaxLength(50);

            this.Property(t => t.idPessup)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("Pessup");
            this.Property(t => t.pessup_codigo).HasColumnName("pessup_codigo");
            this.Property(t => t.pessup_comis_flag).HasColumnName("pessup_comis_flag");
            this.Property(t => t.pessup_comis_tipo).HasColumnName("pessup_comis_tipo");
            this.Property(t => t.pessup_comis_percentual).HasColumnName("pessup_comis_percentual");
            this.Property(t => t.pessup_desabilitado).HasColumnName("pessup_desabilitado");
            this.Property(t => t.PESSUP_CARGO).HasColumnName("PESSUP_CARGO");
            this.Property(t => t.idPessup).HasColumnName("idPessup");
        }
    }
}
