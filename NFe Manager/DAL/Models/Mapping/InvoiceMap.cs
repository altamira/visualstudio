using System.Data.Entity.ModelConfiguration;
using Model;

namespace DAL.Models.Mapping
{
    public class InvoiceMap : EntityTypeConfiguration<Invoice>
    {
        public InvoiceMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Key)
                .IsRequired()
                .HasMaxLength(44);

            //this.Property(t => t.Hash)
            //    .HasMaxLength(64);

            //this.Property(t => t.Xml)
            //    .IsRequired();

            // Table & Column Mappings
            this.ToTable("Invoice", "NFe");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.Date).HasColumnName("Date");
            this.Property(t => t.Number).HasColumnName("Number");
            this.Property(t => t.Value).HasColumnName("Value");
            this.Property(t => t.Sender).HasColumnName("Sender");
            this.Property(t => t.Receipt).HasColumnName("Receipt");
            this.Property(t => t.Key).HasColumnName("Key");
            this.Property(t => t.Type).HasColumnName("Type");
            this.Property(t => t.Status).HasColumnName("Status");

            //this.Property(t => t.Hash).HasColumnName("Hash");
            //this.Property(t => t.Xml).HasColumnName("Xml");

            this.Ignore(t => t.Hash);
            this.Ignore(t => t.Xml);
        }
    }
}
