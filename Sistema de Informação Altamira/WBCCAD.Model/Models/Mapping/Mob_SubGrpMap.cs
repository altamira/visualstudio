using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class Mob_SubGrpMap : EntityTypeConfiguration<Mob_SubGrp>
    {
        public Mob_SubGrpMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobSubGrp);

            // Properties
            this.Property(t => t.Nome_Eqpto)
                .HasMaxLength(50);

            this.Property(t => t.SubGrupo)
                .HasMaxLength(50);

            this.Property(t => t.Tipo_cad)
                .HasMaxLength(4);

            // Table & Column Mappings
            this.ToTable("Mob_SubGrp");
            this.Property(t => t.Nome_Eqpto).HasColumnName("Nome_Eqpto");
            this.Property(t => t.SubGrupo).HasColumnName("SubGrupo");
            this.Property(t => t.Tipo_cad).HasColumnName("Tipo_cad");
            this.Property(t => t.esconder_projeto).HasColumnName("esconder_projeto");
            this.Property(t => t.tratar_como_caracteristica).HasColumnName("tratar_como_caracteristica");
            this.Property(t => t.idMobSubGrp).HasColumnName("idMobSubGrp");
        }
    }
}
