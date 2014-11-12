using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ConfiguracoesTabelaMap : EntityTypeConfiguration<ConfiguracoesTabela>
    {
        public ConfiguracoesTabelaMap()
        {
            // Primary Key
            this.HasKey(t => t.idTabela);

            // Properties
            this.Property(t => t.NomeTabela)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("ConfiguracoesTabelas");
            this.Property(t => t.idTabela).HasColumnName("idTabela");
            this.Property(t => t.NomeTabela).HasColumnName("NomeTabela");
            this.Property(t => t.StringXML).HasColumnName("StringXML");
        }
    }
}
