using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblGrupoBuscaMap : EntityTypeConfiguration<tblGrupoBusca>
    {
        public tblGrupoBuscaMap()
        {
            // Primary Key
            this.HasKey(t => t.idTblGrupoBusca);

            // Properties
            this.Property(t => t.GrupoBusca)
                .HasMaxLength(50);

            this.Property(t => t.Base)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("tblGrupoBusca");
            this.Property(t => t.GrupoBusca).HasColumnName("GrupoBusca");
            this.Property(t => t.Base).HasColumnName("Base");
            this.Property(t => t.idTblGrupoBusca).HasColumnName("idTblGrupoBusca");
        }
    }
}
