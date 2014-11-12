using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblPgtCabModalidadeMap : EntityTypeConfiguration<tblPgtCabModalidade>
    {
        public tblPgtCabModalidadeMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idTblPgtCabModalidade, t.Modalidade, t.Ativa });

            // Properties
            this.Property(t => t.idTblPgtCabModalidade)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.Modalidade)
                .IsRequired()
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("tblPgtCabModalidade");
            this.Property(t => t.idTblPgtCabModalidade).HasColumnName("idTblPgtCabModalidade");
            this.Property(t => t.Modalidade).HasColumnName("Modalidade");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativa).HasColumnName("Ativa");
        }
    }
}
