using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcCrtMap : EntityTypeConfiguration<OrcCrt>
    {
        public OrcCrtMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcCrt);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.orccrt_corte)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_departamento)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_nr_seq)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_setor)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_subgrupo)
                .HasMaxLength(2);

            this.Property(t => t.orccrt_utilizacao)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_viz_atras)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_viz_final)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_viz_inicio)
                .HasMaxLength(50);

            this.Property(t => t.orccrt_item)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcCrt");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.orccrt_altura).HasColumnName("orccrt_altura");
            this.Property(t => t.orccrt_altura_base).HasColumnName("orccrt_altura_base");
            this.Property(t => t.orccrt_largura).HasColumnName("orccrt_largura");
            this.Property(t => t.orccrt_profundidade).HasColumnName("orccrt_profundidade");
            this.Property(t => t.orccrt_cabeceiras).HasColumnName("orccrt_cabeceiras");
            this.Property(t => t.orccrt_cap_termica).HasColumnName("orccrt_cap_termica");
            this.Property(t => t.orccrt_corte).HasColumnName("orccrt_corte");
            this.Property(t => t.orccrt_decibeis).HasColumnName("orccrt_decibeis");
            this.Property(t => t.orccrt_departamento).HasColumnName("orccrt_departamento");
            this.Property(t => t.orccrt_estrutura).HasColumnName("orccrt_estrutura");
            this.Property(t => t.orccrt_folga).HasColumnName("orccrt_folga");
            this.Property(t => t.orccrt_grupo).HasColumnName("orccrt_grupo");
            this.Property(t => t.orccrt_hp).HasColumnName("orccrt_hp");
            this.Property(t => t.orccrt_largura_cabeceira).HasColumnName("orccrt_largura_cabeceira");
            this.Property(t => t.orccrt_nr_seq).HasColumnName("orccrt_nr_seq");
            this.Property(t => t.orccrt_setor).HasColumnName("orccrt_setor");
            this.Property(t => t.orccrt_subgrupo).HasColumnName("orccrt_subgrupo");
            this.Property(t => t.orccrt_tipo_corte).HasColumnName("orccrt_tipo_corte");
            this.Property(t => t.orccrt_utilizacao).HasColumnName("orccrt_utilizacao");
            this.Property(t => t.orccrt_valor_total).HasColumnName("orccrt_valor_total");
            this.Property(t => t.orccrt_viz_atras).HasColumnName("orccrt_viz_atras");
            this.Property(t => t.orccrt_viz_final).HasColumnName("orccrt_viz_final");
            this.Property(t => t.orccrt_viz_inicio).HasColumnName("orccrt_viz_inicio");
            this.Property(t => t.idOrcCrt).HasColumnName("idOrcCrt");
            this.Property(t => t.orccrt_item).HasColumnName("orccrt_item");
        }
    }
}
