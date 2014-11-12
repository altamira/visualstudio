using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PesvndMap : EntityTypeConfiguration<Pesvnd>
    {
        public PesvndMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pesvnd_codigo, t.pesvnd_comis_flag, t.pesvnd_desabilitado, t.idPesvnd });

            // Properties
            this.Property(t => t.pesvnd_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.pesvnd_comis_tipo)
                .HasMaxLength(20);

            this.Property(t => t.pesvnd_tipo)
                .HasMaxLength(20);

            this.Property(t => t.PESVND_CARGO)
                .HasMaxLength(50);

            this.Property(t => t.idPesvnd)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("Pesvnd");
            this.Property(t => t.pesvnd_codigo).HasColumnName("pesvnd_codigo");
            this.Property(t => t.pesvnd_comis_flag).HasColumnName("pesvnd_comis_flag");
            this.Property(t => t.pesvnd_comis_tipo).HasColumnName("pesvnd_comis_tipo");
            this.Property(t => t.pesvnd_comis_percentual).HasColumnName("pesvnd_comis_percentual");
            this.Property(t => t.pesvnd_tipo).HasColumnName("pesvnd_tipo");
            this.Property(t => t.pesvnd_desabilitado).HasColumnName("pesvnd_desabilitado");
            this.Property(t => t.PESVND_CARGO).HasColumnName("PESVND_CARGO");
            this.Property(t => t.PESVND_IMAGEM).HasColumnName("PESVND_IMAGEM");
            this.Property(t => t.idPesvnd).HasColumnName("idPesvnd");
        }
    }
}
