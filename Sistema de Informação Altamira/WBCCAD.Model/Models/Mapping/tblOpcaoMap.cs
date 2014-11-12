using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblOpcaoMap : EntityTypeConfiguration<tblOpcao>
    {
        public tblOpcaoMap()
        {
            // Primary Key
            this.HasKey(t => t.id);

            // Properties
            this.Property(t => t.OpcaoChave)
                .HasMaxLength(50);

            this.Property(t => t.OpcaoValor1)
                .HasMaxLength(255);

            this.Property(t => t.grupo)
                .HasMaxLength(50);

            this.Property(t => t.lista)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("tblOpcao");
            this.Property(t => t.OpcaoChave).HasColumnName("OpcaoChave");
            this.Property(t => t.OpcaoValor1).HasColumnName("OpcaoValor1");
            this.Property(t => t.grupo).HasColumnName("grupo");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.id).HasColumnName("id");
        }
    }
}
