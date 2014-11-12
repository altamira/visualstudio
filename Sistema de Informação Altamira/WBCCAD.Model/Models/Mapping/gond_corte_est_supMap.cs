using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_est_supMap : EntityTypeConfiguration<gond_corte_est_sup>
    {
        public gond_corte_est_supMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteEstSup);

            // Properties
            this.Property(t => t.est_superior)
                .HasMaxLength(50);

            this.Property(t => t.desenho_planta)
                .HasMaxLength(50);

            this.Property(t => t.pos_insercao)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_est_sup");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.est_superior).HasColumnName("est_superior");
            this.Property(t => t.id_corte_est_superior).HasColumnName("id_corte_est_superior");
            this.Property(t => t.desenho_planta).HasColumnName("desenho_planta");
            this.Property(t => t.pos_insercao).HasColumnName("pos_insercao");
            this.Property(t => t.idGondCorteEstSup).HasColumnName("idGondCorteEstSup");
        }
    }
}
