using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arm_piso_acessorios_GEN_bkMap : EntityTypeConfiguration<arm_piso_acessorios_GEN_bk>
    {
        public arm_piso_acessorios_GEN_bkMap()
        {
            // Primary Key
            this.HasKey(t => t.idArmPisoAcessoriosGEN);

            // Properties
            this.Property(t => t.Descricao)
                .HasMaxLength(255);

            this.Property(t => t.codigo)
                .HasMaxLength(255);

            this.Property(t => t.formula_quantidade)
                .HasMaxLength(255);

            this.Property(t => t.tipo_incluir)
                .HasMaxLength(255);

            this.Property(t => t.Tipo_apoio_incluir)
                .HasMaxLength(255);

            this.Property(t => t.formula_dimensao)
                .HasMaxLength(255);

            this.Property(t => t.codigo_juncao)
                .HasMaxLength(255);

            this.Property(t => t.descricao_cantoneira)
                .HasMaxLength(255);

            this.Property(t => t.des_retang_ref)
                .HasMaxLength(255);

            this.Property(t => t.cor_des_retang_ref)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("arm_piso_acessorios_GEN_bk");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.formula_quantidade).HasColumnName("formula_quantidade");
            this.Property(t => t.tipo_incluir).HasColumnName("tipo_incluir");
            this.Property(t => t.Tipo_apoio_incluir).HasColumnName("Tipo_apoio_incluir");
            this.Property(t => t.formula_dimensao).HasColumnName("formula_dimensao");
            this.Property(t => t.multiplo).HasColumnName("multiplo");
            this.Property(t => t.dimensao_maxima_sem_juncao).HasColumnName("dimensao_maxima_sem_juncao");
            this.Property(t => t.codigo_juncao).HasColumnName("codigo_juncao");
            this.Property(t => t.dimensao_padrao).HasColumnName("dimensao_padrao");
            this.Property(t => t.descricao_cantoneira).HasColumnName("descricao_cantoneira");
            this.Property(t => t.para_piso_intermediario).HasColumnName("para_piso_intermediario");
            this.Property(t => t.tratar_como_piso).HasColumnName("tratar_como_piso");
            this.Property(t => t.comprimento_maximo_aceitar).HasColumnName("comprimento_maximo_aceitar");
            this.Property(t => t.comprimento_minimo_aceitar).HasColumnName("comprimento_minimo_aceitar");
            this.Property(t => t.Aces_des_por_Pontos).HasColumnName("Aces_des_por_Pontos");
            this.Property(t => t.des_retang_ref).HasColumnName("des_retang_ref");
            this.Property(t => t.cor_des_retang_ref).HasColumnName("cor_des_retang_ref");
            this.Property(t => t.idArmPisoAcessoriosGEN).HasColumnName("idArmPisoAcessoriosGEN");
        }
    }
}
