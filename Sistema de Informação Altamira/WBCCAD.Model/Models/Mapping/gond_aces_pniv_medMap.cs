using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_aces_pniv_medMap : EntityTypeConfiguration<gond_aces_pniv_med>
    {
        public gond_aces_pniv_medMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcesPnivMed);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.aces_med_med_tipo)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("gond_aces_pniv_med");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.aces_med_med_tipo).HasColumnName("aces_med_med_tipo");
            this.Property(t => t.aces_med_med_med).HasColumnName("aces_med_med_med");
            this.Property(t => t.aces_qpn_valor).HasColumnName("aces_qpn_valor");
            this.Property(t => t.idGondAcesPnivMed).HasColumnName("idGondAcesPnivMed");
        }
    }
}
