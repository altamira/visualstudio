using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtosMap : EntityTypeConfiguration<gond_cjtos>
    {
        public gond_cjtosMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtos);

            // Properties
            this.Property(t => t.descricao_cjto)
                .HasMaxLength(50);

            this.Property(t => t.mensagem_nao_padrao)
                .HasMaxLength(200);

            // Table & Column Mappings
            this.ToTable("gond_cjtos");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.dep_compr).HasColumnName("dep_compr");
            this.Property(t => t.dep_alt).HasColumnName("dep_alt");
            this.Property(t => t.dep_frente).HasColumnName("dep_frente");
            this.Property(t => t.dep_frontal).HasColumnName("dep_frontal");
            this.Property(t => t.dep_posicao).HasColumnName("dep_posicao");
            this.Property(t => t.dep_prof).HasColumnName("dep_prof");
            this.Property(t => t.ig_auto).HasColumnName("ig_auto");
            this.Property(t => t.dep_prof_outro_lado).HasColumnName("dep_prof_outro_lado");
            this.Property(t => t.ANGULO_INCLINACAO).HasColumnName("ANGULO_INCLINACAO");
            this.Property(t => t.mensagem_nao_padrao).HasColumnName("mensagem_nao_padrao");
            this.Property(t => t.idGondCjtos).HasColumnName("idGondCjtos");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
        }
    }
}
