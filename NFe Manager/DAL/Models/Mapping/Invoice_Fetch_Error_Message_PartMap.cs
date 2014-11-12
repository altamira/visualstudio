using System.Data.Entity.ModelConfiguration;
using Model;

namespace DAL.Models.Mapping
{
    public class Invoice_Fetch_Error_Message_PartMap : EntityTypeConfiguration<Invoice_Fetch_Error_Message_Part>
    {
        public Invoice_Fetch_Error_Message_PartMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.ContentType)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.MessagePart)
                .IsRequired();

            this.Property(t => t.ExceptionType)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.Error)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Invoice.Fetch.Error.Message.Part", "NFe");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Message).HasColumnName("Message");
            this.Property(t => t.ContentType).HasColumnName("ContentType");
            this.Property(t => t.MessagePart).HasColumnName("MessagePart");
            this.Property(t => t.ExceptionType).HasColumnName("ExceptionType");
            this.Property(t => t.Error).HasColumnName("Error");
        }
    }
}
