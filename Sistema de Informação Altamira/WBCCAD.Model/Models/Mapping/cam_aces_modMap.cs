using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cam_aces_modMap : EntityTypeConfiguration<cam_aces_mod>
    {
        public cam_aces_modMap()
        {
            // Primary Key
            this.HasKey(t => t.e_por_perimetro);

            // Properties
            this.Property(t => t.sigla)
                .HasMaxLength(20);

            this.Property(t => t.sigla_aces)
                .HasMaxLength(20);

            this.Property(t => t.acabamento)
                .HasMaxLength(10);

            this.Property(t => t.formula_quantidade)
                .HasMaxLength(100);

            this.Property(t => t.tipo_cad)
                .HasMaxLength(5);

            // Table & Column Mappings
            this.ToTable("cam_aces_mod");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.sigla_aces).HasColumnName("sigla_aces");
            this.Property(t => t.acabamento).HasColumnName("acabamento");
            this.Property(t => t.formula_quantidade).HasColumnName("formula_quantidade");
            this.Property(t => t.temperatura).HasColumnName("temperatura");
            this.Property(t => t.temperatura_minima).HasColumnName("temperatura_minima");
            this.Property(t => t.temperatura_maxima).HasColumnName("temperatura_maxima");
            this.Property(t => t.e_por_perimetro).HasColumnName("e_por_perimetro");
            this.Property(t => t.tipo_cad).HasColumnName("tipo_cad");
        }
    }
}
