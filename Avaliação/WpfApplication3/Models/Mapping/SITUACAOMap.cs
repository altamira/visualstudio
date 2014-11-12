using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WpfApplication3.Models.Mapping
{
    public class SITUACAOMap : EntityTypeConfiguration<SITUACAO>
    {
        public SITUACAOMap()
        {
            // Primary Key
            this.HasKey(t => t.CODIGO);

            // Properties
            this.Property(t => t.CODIGO)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.DESCRICAO)
                .IsRequired()
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("SITUACAO");
            this.Property(t => t.CODIGO).HasColumnName("CODIGO");
            this.Property(t => t.DESCRICAO).HasColumnName("DESCRICAO");
        }
    }
}
