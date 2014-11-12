using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_angMap : EntityTypeConfiguration<gond_ang>
    {
        public gond_angMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAng);

            // Properties
            this.Property(t => t.angulo)
                .HasMaxLength(50);

            this.Property(t => t.angulo_oposto)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_ang");
            this.Property(t => t.angulo).HasColumnName("angulo");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.dep_comprimento).HasColumnName("dep_comprimento");
            this.Property(t => t.idGondAng).HasColumnName("idGondAng");
            this.Property(t => t.angulo_oposto).HasColumnName("angulo_oposto");
            this.Property(t => t.comprimento_lado).HasColumnName("comprimento_lado");
            this.Property(t => t.valor_angulo).HasColumnName("valor_angulo");
        }
    }
}
