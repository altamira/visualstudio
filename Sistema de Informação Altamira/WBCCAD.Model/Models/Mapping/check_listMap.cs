using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class check_listMap : EntityTypeConfiguration<check_list>
    {
        public check_listMap()
        {
            // Primary Key
            this.HasKey(t => new { t.opcao, t.permitir_edicao, t.ativo });

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.grupo)
                .HasMaxLength(50);

            this.Property(t => t.imagem)
                .HasMaxLength(50);

            this.Property(t => t.comando_executar)
                .HasMaxLength(50);

            this.Property(t => t.lista_dados)
                .HasMaxLength(250);

            this.Property(t => t.Valor_padrao)
                .HasMaxLength(50);

            this.Property(t => t.Variavel_projeto)
                .HasMaxLength(50);

            this.Property(t => t.tag_atributo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("check_list");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.grupo).HasColumnName("grupo");
            this.Property(t => t.imagem).HasColumnName("imagem");
            this.Property(t => t.comando_executar).HasColumnName("comando_executar");
            this.Property(t => t.lista_dados).HasColumnName("lista_dados");
            this.Property(t => t.opcao).HasColumnName("opcao");
            this.Property(t => t.ordem).HasColumnName("ordem");
            this.Property(t => t.Valor_padrao).HasColumnName("Valor_padrao");
            this.Property(t => t.tempo_apresentacao).HasColumnName("tempo_apresentacao");
            this.Property(t => t.Variavel_projeto).HasColumnName("Variavel_projeto");
            this.Property(t => t.permitir_edicao).HasColumnName("permitir_edicao");
            this.Property(t => t.ativo).HasColumnName("ativo");
            this.Property(t => t.tag_atributo).HasColumnName("tag_atributo");
        }
    }
}
