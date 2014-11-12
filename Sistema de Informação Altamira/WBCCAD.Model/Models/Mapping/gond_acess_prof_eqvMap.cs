using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_acess_prof_eqvMap : EntityTypeConfiguration<gond_acess_prof_eqv>
    {
        public gond_acess_prof_eqvMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcessProfEqv);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.ang)
                .HasMaxLength(50);

            this.Property(t => t.tipo_frente)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gond_acess_prof_eqv");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.ang).HasColumnName("ang");
            this.Property(t => t.tipo_frente).HasColumnName("tipo_frente");
            this.Property(t => t.id_corte_frontal).HasColumnName("id_corte_frontal");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.equivalencia).HasColumnName("equivalencia");
            this.Property(t => t.idGondAcessProfEqv).HasColumnName("idGondAcessProfEqv");
        }
    }
}
