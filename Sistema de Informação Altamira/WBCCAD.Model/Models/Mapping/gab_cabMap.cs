using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_cabMap : EntityTypeConfiguration<gab_cab>
    {
        public gab_cabMap()
        {
            // Primary Key
            this.HasKey(t => new { t.esconder_orcamento, t.e_intermediaria });

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(30);

            this.Property(t => t.grupo)
                .HasMaxLength(20);

            this.Property(t => t.codigo_produto)
                .HasMaxLength(20);

            this.Property(t => t.desenho)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gab_cab");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.grupo).HasColumnName("grupo");
            this.Property(t => t.codigo_produto).HasColumnName("codigo_produto");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.largura).HasColumnName("largura");
            this.Property(t => t.esconder_orcamento).HasColumnName("esconder_orcamento");
            this.Property(t => t.sequencia_para_edicao).HasColumnName("sequencia_para_edicao");
            this.Property(t => t.e_intermediaria).HasColumnName("e_intermediaria");
        }
    }
}
