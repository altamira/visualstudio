using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_est_frtMap : EntityTypeConfiguration<gond_corte_est_frt>
    {
        public gond_corte_est_frtMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteEstFrt);

            // Properties
            this.Property(t => t.est_frontal)
                .HasMaxLength(50);

            this.Property(t => t.desenho_planta)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_est_frt");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.est_frontal).HasColumnName("est_frontal");
            this.Property(t => t.id_corte_est_frontal).HasColumnName("id_corte_est_frontal");
            this.Property(t => t.desenho_planta).HasColumnName("desenho_planta");
            this.Property(t => t.pos_insercao).HasColumnName("pos_insercao");
            this.Property(t => t.idGondCorteEstFrt).HasColumnName("idGondCorteEstFrt");
        }
    }
}
