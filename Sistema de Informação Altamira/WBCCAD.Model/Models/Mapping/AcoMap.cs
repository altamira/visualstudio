using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class AcoMap : EntityTypeConfiguration<Aco>
    {
        public AcoMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idAcao, t.idTipoAcao, t.idAplicacao, t.Chave, t.Exibir });

            // Properties
            this.Property(t => t.idAcao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.idTipoAcao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idAplicacao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.AcaoPT)
                .HasMaxLength(255);

            this.Property(t => t.AcaoEN)
                .HasMaxLength(255);

            this.Property(t => t.AcaoES)
                .HasMaxLength(255);

            this.Property(t => t.Chave)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.LinhaComando)
                .HasMaxLength(255);

            this.Property(t => t.DiretorioInicial)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Acoes");
            this.Property(t => t.idAcao).HasColumnName("idAcao");
            this.Property(t => t.idAcaoPai).HasColumnName("idAcaoPai");
            this.Property(t => t.idTipoAcao).HasColumnName("idTipoAcao");
            this.Property(t => t.idAplicacao).HasColumnName("idAplicacao");
            this.Property(t => t.AcaoPT).HasColumnName("AcaoPT");
            this.Property(t => t.AcaoEN).HasColumnName("AcaoEN");
            this.Property(t => t.AcaoES).HasColumnName("AcaoES");
            this.Property(t => t.Chave).HasColumnName("Chave");
            this.Property(t => t.LinhaComando).HasColumnName("LinhaComando");
            this.Property(t => t.DiretorioInicial).HasColumnName("DiretorioInicial");
            this.Property(t => t.Parametros).HasColumnName("Parametros");
            this.Property(t => t.ObservacoesPT).HasColumnName("ObservacoesPT");
            this.Property(t => t.ObservacoesEN).HasColumnName("ObservacoesEN");
            this.Property(t => t.ObservacoesES).HasColumnName("ObservacoesES");
            this.Property(t => t.Exibir).HasColumnName("Exibir");
        }
    }
}
