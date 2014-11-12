using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class AplicacoMap : EntityTypeConfiguration<Aplicaco>
    {
        public AplicacoMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idAplicacao, t.Ativa, t.Principal, t.ArquivosPrograma });

            // Properties
            this.Property(t => t.idAplicacao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.AplicacaoPT)
                .HasMaxLength(100);

            this.Property(t => t.AplicacaoEN)
                .HasMaxLength(255);

            this.Property(t => t.AplicacaoES)
                .HasMaxLength(255);

            this.Property(t => t.Executavel)
                .HasMaxLength(100);

            this.Property(t => t.chave)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Aplicacoes");
            this.Property(t => t.idAplicacao).HasColumnName("idAplicacao");
            this.Property(t => t.AplicacaoPT).HasColumnName("AplicacaoPT");
            this.Property(t => t.AplicacaoEN).HasColumnName("AplicacaoEN");
            this.Property(t => t.AplicacaoES).HasColumnName("AplicacaoES");
            this.Property(t => t.Executavel).HasColumnName("Executavel");
            this.Property(t => t.Parametros).HasColumnName("Parametros");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativa).HasColumnName("Ativa");
            this.Property(t => t.Principal).HasColumnName("Principal");
            this.Property(t => t.ArquivosPrograma).HasColumnName("ArquivosPrograma");
            this.Property(t => t.chave).HasColumnName("chave");
        }
    }
}
