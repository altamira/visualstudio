using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class GrpPrecoMap : EntityTypeConfiguration<GrpPreco>
    {
        public GrpPrecoMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idGrpPreco, t.GrpPreco_descricao, t.GenGrpPrecoCodigo, t.Produto, t.GenGrpPrecoFator });

            // Properties
            this.Property(t => t.idGrpPreco)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.GrpPreco_descricao)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.GenGrpPrecoCodigo)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(50);

            this.Property(t => t.Produto)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("GrpPreco");
            this.Property(t => t.idGrpPreco).HasColumnName("idGrpPreco");
            this.Property(t => t.GrpPreco_descricao).HasColumnName("GrpPreco_descricao");
            this.Property(t => t.GenGrpPrecoCodigo).HasColumnName("GenGrpPrecoCodigo");
            this.Property(t => t.Produto).HasColumnName("Produto");
            this.Property(t => t.GenGrpPrecoFator).HasColumnName("GenGrpPrecoFator");
        }
    }
}
