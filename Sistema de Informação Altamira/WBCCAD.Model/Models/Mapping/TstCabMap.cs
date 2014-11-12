using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TstCabMap : EntityTypeConfiguration<TstCab>
    {
        public TstCabMap()
        {
            // Primary Key
            this.HasKey(t => t.TstCabCodigo);

            // Properties
            this.Property(t => t.TstCabCodigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.TstCabDescricao)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("TstCab");
            this.Property(t => t.TstCabCodigo).HasColumnName("TstCabCodigo");
            this.Property(t => t.TstCabDescricao).HasColumnName("TstCabDescricao");
            this.Property(t => t.TstCabBloqueado).HasColumnName("TstCabBloqueado");
            this.Property(t => t.TstCabData).HasColumnName("TstCabData");
            this.Property(t => t.TstCabValor).HasColumnName("TstCabValor");
        }
    }
}
