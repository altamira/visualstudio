using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PesusrMap : EntityTypeConfiguration<Pesusr>
    {
        public PesusrMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pesusr_senha, t.pesusr_trocar_senha, t.pesusr_bloquear_acesso, t.pesusr_desabilitado });

            // Properties
            this.Property(t => t.pesusr_senha)
                .IsRequired()
                .HasMaxLength(8);

            this.Property(t => t.pesusr_assinatura)
                .HasMaxLength(8);

            // Table & Column Mappings
            this.ToTable("Pesusr");
            this.Property(t => t.pesusr_codigo).HasColumnName("pesusr_codigo");
            this.Property(t => t.pesusr_senha).HasColumnName("pesusr_senha");
            this.Property(t => t.pesusr_assinatura).HasColumnName("pesusr_assinatura");
            this.Property(t => t.pesusr_trocar_senha).HasColumnName("pesusr_trocar_senha");
            this.Property(t => t.pesusr_proxima_troca).HasColumnName("pesusr_proxima_troca");
            this.Property(t => t.pesusr_bloquear_acesso).HasColumnName("pesusr_bloquear_acesso");
            this.Property(t => t.pesusr_validade).HasColumnName("pesusr_validade");
            this.Property(t => t.pesusr_desabilitado).HasColumnName("pesusr_desabilitado");
        }
    }
}
