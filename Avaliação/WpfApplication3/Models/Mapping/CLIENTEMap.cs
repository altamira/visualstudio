using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WpfApplication3.Models.Mapping
{
    public class CLIENTEMap : EntityTypeConfiguration<CLIENTE>
    {
        public CLIENTEMap()
        {
            // Primary Key
            this.HasKey(t => t.CODIGO);

            // Properties
            this.Property(t => t.CODIGO)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.NOME)
                .IsRequired()
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("CLIENTE");
            this.Property(t => t.CODIGO).HasColumnName("CODIGO");
            this.Property(t => t.NOME).HasColumnName("NOME");
        }
    }
}
