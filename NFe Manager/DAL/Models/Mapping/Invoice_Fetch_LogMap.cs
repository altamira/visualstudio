using System.Data.Entity.ModelConfiguration;
using Model;

namespace DAL.Models.Mapping
{
    public class Invoice_Fetch_LogMap : EntityTypeConfiguration<Invoice_Fetch_Log>
    {
        public Invoice_Fetch_LogMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.History)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Invoice.Fetch.Log", "NFe");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.DateTime).HasColumnName("DateTime");
            this.Property(t => t.History).HasColumnName("History");
        }
    }
}
