using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_tp_frtMap : EntityTypeConfiguration<gond_tp_frt>
    {
        public gond_tp_frtMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondTpFrt);

            // Properties
            this.Property(t => t.Tipo_frente)
                .HasMaxLength(50);

            this.Property(t => t.frente_lado_oposto)
                .HasMaxLength(50);

            this.Property(t => t.sufixo_tipo)
                .HasMaxLength(2);

            this.Property(t => t.prefixo_estrutura)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("gond_tp_frt");
            this.Property(t => t.Tipo_frente).HasColumnName("Tipo_frente");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.dep_dimensoes).HasColumnName("dep_dimensoes");
            this.Property(t => t.frente_lado_oposto).HasColumnName("frente_lado_oposto");
            this.Property(t => t.sufixo_tipo).HasColumnName("sufixo_tipo");
            this.Property(t => t.incluir_estrutura).HasColumnName("incluir_estrutura");
            this.Property(t => t.idGondTpFrt).HasColumnName("idGondTpFrt");
            this.Property(t => t.prefixo_estrutura).HasColumnName("prefixo_estrutura");
        }
    }
}
