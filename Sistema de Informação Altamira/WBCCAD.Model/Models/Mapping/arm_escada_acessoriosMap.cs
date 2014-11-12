using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arm_escada_acessoriosMap : EntityTypeConfiguration<arm_escada_acessorios>
    {
        public arm_escada_acessoriosMap()
        {
            // Primary Key
            this.HasKey(t => t.acess_guarda_corpo);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(100);

            this.Property(t => t.codigo)
                .HasMaxLength(50);

            this.Property(t => t.formula_dimensao)
                .HasMaxLength(250);

            this.Property(t => t.formula_quantidade)
                .HasMaxLength(250);

            this.Property(t => t.tipo_incluir)
                .HasMaxLength(50);

            this.Property(t => t.formula_comprimento)
                .HasMaxLength(250);

            this.Property(t => t.formula_altura)
                .HasMaxLength(250);

            this.Property(t => t.formula_profundidade)
                .HasMaxLength(250);

            this.Property(t => t.tipo_piso)
                .HasMaxLength(50);

            this.Property(t => t.tipo_cad)
                .HasMaxLength(3);

            this.Property(t => t.codigo_juncao)
                .HasMaxLength(50);

            this.Property(t => t.grupo_acab)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("arm_escada_acessorios");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.formula_dimensao).HasColumnName("formula_dimensao");
            this.Property(t => t.formula_quantidade).HasColumnName("formula_quantidade");
            this.Property(t => t.tipo_incluir).HasColumnName("tipo_incluir");
            this.Property(t => t.formula_comprimento).HasColumnName("formula_comprimento");
            this.Property(t => t.formula_altura).HasColumnName("formula_altura");
            this.Property(t => t.formula_profundidade).HasColumnName("formula_profundidade");
            this.Property(t => t.tipo_piso).HasColumnName("tipo_piso");
            this.Property(t => t.tipo_cad).HasColumnName("tipo_cad");
            this.Property(t => t.multiplo).HasColumnName("multiplo");
            this.Property(t => t.dimensao_maxima_sem_juncao).HasColumnName("dimensao_maxima_sem_juncao");
            this.Property(t => t.codigo_juncao).HasColumnName("codigo_juncao");
            this.Property(t => t.comprimento_maximo_aceitar).HasColumnName("comprimento_maximo_aceitar");
            this.Property(t => t.comprimento_minimo_aceitar).HasColumnName("comprimento_minimo_aceitar");
            this.Property(t => t.profundidade_padrao).HasColumnName("profundidade_padrao");
            this.Property(t => t.largura_maxima_aceitar).HasColumnName("largura_maxima_aceitar");
            this.Property(t => t.largura_minima_aceitar).HasColumnName("largura_minima_aceitar");
            this.Property(t => t.acess_guarda_corpo).HasColumnName("acess_guarda_corpo");
            this.Property(t => t.grupo_acab).HasColumnName("grupo_acab");
        }
    }
}
