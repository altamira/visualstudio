using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TraducaoMap : EntityTypeConfiguration<Traducao>
    {
        public TraducaoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTraducao);

            // Properties
            this.Property(t => t.Complemento)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Traducao");
            this.Property(t => t.idTraducao).HasColumnName("idTraducao");
            this.Property(t => t.PalavraChave).HasColumnName("PalavraChave");
            this.Property(t => t.Complemento).HasColumnName("Complemento");
            this.Property(t => t.TraducaoEN).HasColumnName("TraducaoEN");
            this.Property(t => t.TraducaoES).HasColumnName("TraducaoES");
            this.Property(t => t.TraducaoPT).HasColumnName("TraducaoPT");
            this.Property(t => t.TraducaoIT).HasColumnName("TraducaoIT");
        }
    }
}
