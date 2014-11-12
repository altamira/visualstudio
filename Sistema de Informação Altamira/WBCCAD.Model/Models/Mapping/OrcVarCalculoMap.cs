using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcVarCalculoMap : EntityTypeConfiguration<OrcVarCalculo>
    {
        public OrcVarCalculoMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcVarCalculo);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcVarCalculo");
            this.Property(t => t.idOrcVarCalculo).HasColumnName("idOrcVarCalculo");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.Chave).HasColumnName("Chave");
            this.Property(t => t.Valor).HasColumnName("Valor");
            this.Property(t => t.ChaveImpressao).HasColumnName("ChaveImpressao");
            this.Property(t => t.DistribuirValor).HasColumnName("DistribuirValor");
            this.Property(t => t.Servico).HasColumnName("Servico");
        }
    }
}
