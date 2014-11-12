using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_aces_dependenteMap : EntityTypeConfiguration<mob_aces_dependente>
    {
        public mob_aces_dependenteMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobAcesDependente);

            // Properties
            this.Property(t => t.descricao_aces)
                .HasMaxLength(100);

            this.Property(t => t.descricao_aces_dependente)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("mob_aces_dependente");
            this.Property(t => t.descricao_aces).HasColumnName("descricao_aces");
            this.Property(t => t.descricao_aces_dependente).HasColumnName("descricao_aces_dependente");
            this.Property(t => t.idMobAcesDependente).HasColumnName("idMobAcesDependente");
        }
    }
}
