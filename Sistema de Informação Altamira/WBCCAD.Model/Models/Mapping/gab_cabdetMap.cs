using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_cabdetMap : EntityTypeConfiguration<gab_cabdet>
    {
        public gab_cabdetMap()
        {
            // Primary Key
            this.HasKey(t => t.idGabCabdet);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(30);

            this.Property(t => t.flag_e_d)
                .HasMaxLength(1);

            this.Property(t => t.ligacao)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("gab_cabdet");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.flag_e_d).HasColumnName("flag_e_d");
            this.Property(t => t.ligacao).HasColumnName("ligacao");
            this.Property(t => t.e_intermediaria).HasColumnName("e_intermediaria");
            this.Property(t => t.idGabCabdet).HasColumnName("idGabCabdet");
        }
    }
}
