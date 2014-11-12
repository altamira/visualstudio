using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class Log_sysMap : EntityTypeConfiguration<Log_sys>
    {
        public Log_sysMap()
        {
            // Primary Key
            this.HasKey(t => t.AcaoNumero);

            // Properties
            this.Property(t => t.Acao)
                .HasMaxLength(255);

            this.Property(t => t.Modulo)
                .HasMaxLength(50);

            this.Property(t => t.Usuário)
                .HasMaxLength(50);

            this.Property(t => t.Supervisor)
                .HasMaxLength(50);

            this.Property(t => t.Maquina)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Log_sys");
            this.Property(t => t.AcaoNumero).HasColumnName("AcaoNumero");
            this.Property(t => t.Data).HasColumnName("Data");
            this.Property(t => t.Hora).HasColumnName("Hora");
            this.Property(t => t.Acao).HasColumnName("Acao");
            this.Property(t => t.Modulo).HasColumnName("Modulo");
            this.Property(t => t.Usuário).HasColumnName("Usuário");
            this.Property(t => t.Supervisor).HasColumnName("Supervisor");
            this.Property(t => t.Maquina).HasColumnName("Maquina");
        }
    }
}
