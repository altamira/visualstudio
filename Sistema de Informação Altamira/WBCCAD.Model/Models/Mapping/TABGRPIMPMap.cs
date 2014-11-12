using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TABGRPIMPMap : EntityTypeConfiguration<TABGRPIMP>
    {
        public TABGRPIMPMap()
        {
            // Primary Key
            this.HasKey(t => t.idGrupoImposto);

            // Properties
            this.Property(t => t.GrupoImpostos)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("TABGRPIMP");
            this.Property(t => t.GrupoImpostos).HasColumnName("GrupoImpostos");
            this.Property(t => t.idGrupoImposto).HasColumnName("idGrupoImposto");
        }
    }
}
