using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rel_prof_prof_pontaMap : EntityTypeConfiguration<gond_rel_prof_prof_ponta>
    {
        public gond_rel_prof_prof_pontaMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRelProfProfPonta);

            // Properties
            this.Property(t => t.prof_central)
                .HasMaxLength(50);

            this.Property(t => t.prof_ponta)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_rel_prof_prof_ponta");
            this.Property(t => t.prof_central).HasColumnName("prof_central");
            this.Property(t => t.prof_ponta).HasColumnName("prof_ponta");
            this.Property(t => t.idGondRelProfProfPonta).HasColumnName("idGondRelProfProfPonta");
        }
    }
}
