using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_acessoriosMap : EntityTypeConfiguration<mez_acessorios>
    {
        public mez_acessoriosMap()
        {
            // Primary Key
            this.HasKey(t => new { t.vizinho, t.arredondar_baixo, t.ins_pis_metalic, t.Aces_des_por_Pontos });

            // Properties
            this.Property(t => t.formula_dimensao)
                .HasMaxLength(100);

            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.codigo)
                .HasMaxLength(50);

            this.Property(t => t.formula_quantidade)
                .HasMaxLength(100);

            this.Property(t => t.codigo_juncao)
                .HasMaxLength(50);

            this.Property(t => t.tipo_cad)
                .HasMaxLength(50);

            this.Property(t => t.tipo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("mez_acessorios");
            this.Property(t => t.formula_dimensao).HasColumnName("formula_dimensao");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.formula_quantidade).HasColumnName("formula_quantidade");
            this.Property(t => t.dimensao_maxima_sem_juncao).HasColumnName("dimensao_maxima_sem_juncao");
            this.Property(t => t.codigo_juncao).HasColumnName("codigo_juncao");
            this.Property(t => t.tipo_cad).HasColumnName("tipo_cad");
            this.Property(t => t.multiplo).HasColumnName("multiplo");
            this.Property(t => t.comprimento_maximo).HasColumnName("comprimento_maximo");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.vizinho).HasColumnName("vizinho");
            this.Property(t => t.arredondar_baixo).HasColumnName("arredondar_baixo");
            this.Property(t => t.ins_pis_metalic).HasColumnName("ins_pis_metalic");
            this.Property(t => t.Aces_des_por_Pontos).HasColumnName("Aces_des_por_Pontos");
        }
    }
}
