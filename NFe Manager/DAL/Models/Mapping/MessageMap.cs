using System.Data.Entity.ModelConfiguration;
using Model;

namespace DAL.Models.Mapping
{
    public class MessageMap : EntityTypeConfiguration<Message>
    {
        public MessageMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.MessageId)
                .HasMaxLength(512);

            this.Property(t => t.From)
                .HasMaxLength(512);

            this.Property(t => t.Body)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Message", "Mail");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.MessageId).HasColumnName("MessageId");
            this.Property(t => t.Sent).HasColumnName("Sent");
            this.Property(t => t.Received).HasColumnName("Received");
            this.Property(t => t.From).HasColumnName("From");
            this.Property(t => t.To).HasColumnName("To");
            this.Property(t => t.Cc).HasColumnName("Cc");
            this.Property(t => t.Bcc).HasColumnName("Bcc");
            this.Property(t => t.ReplyTo).HasColumnName("ReplyTo");
            this.Property(t => t.InReplyTo).HasColumnName("InReplyTo");
            this.Property(t => t.ReturnPath).HasColumnName("ReturnPath");
            this.Property(t => t.Subject).HasColumnName("Subject");
            this.Property(t => t.Body).HasColumnName("Body");
        }
    }
}
