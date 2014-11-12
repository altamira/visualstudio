using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class varusrMap : EntityTypeConfiguration<varusr>
    {
        public varusrMap()
        {
            // Primary Key
            this.HasKey(t => t.idVarusr);

            // Properties
            this.Property(t => t.varusrcodigo)
                .HasMaxLength(50);

            this.Property(t => t.varusrdescricao)
                .HasMaxLength(1024);

            this.Property(t => t.varusrgrupo)
                .HasMaxLength(50);

            this.Property(t => t.VARUSRPADRAO)
                .HasMaxLength(255);

            this.Property(t => t.VarUsrLista)
                .HasMaxLength(500);

            // Table & Column Mappings
            this.ToTable("varusr");
            this.Property(t => t.idVarusr).HasColumnName("idVarusr");
            this.Property(t => t.varusrcodigo).HasColumnName("varusrcodigo");
            this.Property(t => t.varusrdescricao).HasColumnName("varusrdescricao");
            this.Property(t => t.varusrtipo).HasColumnName("varusrtipo");
            this.Property(t => t.varusrgrupo).HasColumnName("varusrgrupo");
            this.Property(t => t.VARUSRVALOR).HasColumnName("VARUSRVALOR");
            this.Property(t => t.VARUSRPADRAO).HasColumnName("VARUSRPADRAO");
            this.Property(t => t.VarUsrLista).HasColumnName("VarUsrLista");
        }
    }
}
