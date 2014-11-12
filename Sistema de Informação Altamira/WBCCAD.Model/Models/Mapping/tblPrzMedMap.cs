using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblPrzMedMap : EntityTypeConfiguration<tblPrzMed>
    {
        public tblPrzMedMap()
        {
            // Primary Key
            this.HasKey(t => t.idTblPrzMed);

            // Properties
            // Table & Column Mappings
            this.ToTable("tblPrzMed");
            this.Property(t => t.idTblPrzMed).HasColumnName("idTblPrzMed");
            this.Property(t => t.PrzMed_Dias).HasColumnName("PrzMed_Dias");
            this.Property(t => t.PrzMed_Fator).HasColumnName("PrzMed_Fator");
        }
    }
}
