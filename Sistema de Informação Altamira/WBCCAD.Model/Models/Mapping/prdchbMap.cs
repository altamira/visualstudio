using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prdchbMap : EntityTypeConfiguration<prdchb>
    {
        public prdchbMap()
        {
            // Primary Key
            this.HasKey(t => t.idPrdChb);

            // Properties
            this.Property(t => t.Produto)
                .HasMaxLength(20);

            this.Property(t => t.Chave_busca_montada)
                .HasMaxLength(50);

            this.Property(t => t.Chave_busca)
                .HasMaxLength(50);

            this.Property(t => t.Dimensao_1)
                .HasMaxLength(10);

            this.Property(t => t.Dimensao_2)
                .HasMaxLength(10);

            this.Property(t => t.Dimensao_3)
                .HasMaxLength(10);

            this.Property(t => t.Dimensao_4)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("prdchb");
            this.Property(t => t.Produto).HasColumnName("Produto");
            this.Property(t => t.Chave_busca_montada).HasColumnName("Chave_busca_montada");
            this.Property(t => t.Chave_busca).HasColumnName("Chave_busca");
            this.Property(t => t.Dimensao_1).HasColumnName("Dimensao_1");
            this.Property(t => t.Dimensao_2).HasColumnName("Dimensao_2");
            this.Property(t => t.Dimensao_3).HasColumnName("Dimensao_3");
            this.Property(t => t.Dimensao_4).HasColumnName("Dimensao_4");
            this.Property(t => t.Esconder_orcamento).HasColumnName("Esconder_orcamento");
            this.Property(t => t.multiplo).HasColumnName("multiplo");
            this.Property(t => t.dividir_multiplo).HasColumnName("dividir_multiplo");
            this.Property(t => t.multiploVizinho).HasColumnName("multiploVizinho");
            this.Property(t => t.idPrdChb).HasColumnName("idPrdChb");
        }
    }
}
