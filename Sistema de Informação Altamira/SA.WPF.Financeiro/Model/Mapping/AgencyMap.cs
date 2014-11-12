using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.WPF.Financial.Model.Mapping
{
    public class AgencyMap : EntityTypeConfiguration<Agency>
    {
        public AgencyMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Number)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(10);

            this.Property(t => t.Manager)
                .HasMaxLength(50);

            this.Property(t => t.Telephone)
                .IsFixedLength()
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("Agency", "Financial");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.BankId).HasColumnName("Bank");
            this.Property(t => t.Number).HasColumnName("Number");
            this.Property(t => t.Manager).HasColumnName("Manager");
            this.Property(t => t.Telephone).HasColumnName("Telephone");

            // Relationships
            this.HasRequired(t => t.Bank)
                .WithMany(t => t.Agencies)
                .HasForeignKey(d => d.BankId);

        }
    }
}
