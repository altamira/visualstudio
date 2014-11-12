using System.Data.Entity.ModelConfiguration;
using Model;

namespace DAL.Models.Mapping
{
    public class Invoice_Fetch_Error_MessageMap : EntityTypeConfiguration<Invoice_Fetch_Error_Message>
    {
        public Invoice_Fetch_Error_MessageMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.From)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Invoice.Fetch.Error.Message", "NFe");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Sent).HasColumnName("Sent");
            this.Property(t => t.From).HasColumnName("From");
            this.Property(t => t.To).HasColumnName("To");
            this.Property(t => t.Cc).HasColumnName("Cc");
            this.Property(t => t.Bcc).HasColumnName("Bcc");
            this.Property(t => t.Subject).HasColumnName("Subject");
            this.Property(t => t.Body).HasColumnName("Body");
        }
    }
}
