using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cam_detalhes_kitMap : EntityTypeConfiguration<cam_detalhes_kit>
    {
        public cam_detalhes_kitMap()
        {
            // Primary Key
            this.HasKey(t => new { t.DEPENDE_ESPESSURA, t.DEPENDE_ACABAMENTO, t.ESPESSURAS_IGUAIS, t.DEPENDE_TIPO_PAINEL, t.somente_para_coluna, t.somente_para_divisoria, t.somente_alturas_diferentes, t.somente_reentrancia, t.somente_detalhe_piso, t.somente_quebra_frio });

            // Properties
            this.Property(t => t.apelido)
                .HasMaxLength(20);

            this.Property(t => t.PAREDE_VIZINHO)
                .HasMaxLength(10);

            this.Property(t => t.POSICAO_PAINEL)
                .HasMaxLength(10);

            this.Property(t => t.QUAL_ACABAMENTO)
                .HasMaxLength(10);

            this.Property(t => t.QUAL_TIPO)
                .HasMaxLength(10);

            this.Property(t => t.desenho)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("cam_detalhes_kit");
            this.Property(t => t.apelido).HasColumnName("apelido");
            this.Property(t => t.DEPENDE_ESPESSURA).HasColumnName("DEPENDE_ESPESSURA");
            this.Property(t => t.DEPENDE_ACABAMENTO).HasColumnName("DEPENDE_ACABAMENTO");
            this.Property(t => t.QUANTIDADE_PAINEIS).HasColumnName("QUANTIDADE_PAINEIS");
            this.Property(t => t.ANGULO_ENTRE_PAINEIS).HasColumnName("ANGULO_ENTRE_PAINEIS");
            this.Property(t => t.PAREDE_VIZINHO).HasColumnName("PAREDE_VIZINHO");
            this.Property(t => t.POSICAO_PAINEL).HasColumnName("POSICAO_PAINEL");
            this.Property(t => t.ESPESSURAS_IGUAIS).HasColumnName("ESPESSURAS_IGUAIS");
            this.Property(t => t.DEPENDE_TIPO_PAINEL).HasColumnName("DEPENDE_TIPO_PAINEL");
            this.Property(t => t.QUAL_ACABAMENTO).HasColumnName("QUAL_ACABAMENTO");
            this.Property(t => t.QUAL_TIPO).HasColumnName("QUAL_TIPO");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.somente_para_coluna).HasColumnName("somente_para_coluna");
            this.Property(t => t.somente_para_divisoria).HasColumnName("somente_para_divisoria");
            this.Property(t => t.somente_alturas_diferentes).HasColumnName("somente_alturas_diferentes");
            this.Property(t => t.somente_reentrancia).HasColumnName("somente_reentrancia");
            this.Property(t => t.somente_detalhe_piso).HasColumnName("somente_detalhe_piso");
            this.Property(t => t.valor_adicional).HasColumnName("valor_adicional");
            this.Property(t => t.somente_quebra_frio).HasColumnName("somente_quebra_frio");
        }
    }
}
