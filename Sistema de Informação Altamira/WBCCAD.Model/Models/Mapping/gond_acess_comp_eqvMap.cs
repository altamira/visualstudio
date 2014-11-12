using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_acess_comp_eqvMap : EntityTypeConfiguration<gond_acess_comp_eqv>
    {
        public gond_acess_comp_eqvMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcessComprEqv);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_acess_comp_eqv");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.equivalencia).HasColumnName("equivalencia");
            this.Property(t => t.idGondAcessComprEqv).HasColumnName("idGondAcessComprEqv");
        }
    }
}
