using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace SA.WPF.Financial.Model.Mapping
{
    public class AccountMap : EntityTypeConfiguration<Account>
    {
        public AccountMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Number)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(10);

            // Properties
            this.Property(t => t.Balance);

            // Table & Column Mappings
            this.ToTable("Account", "Financial");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.AgencyId).HasColumnName("Agency");
            this.Property(t => t.Number).HasColumnName("Number");
            this.Property(t => t.Balance).HasColumnName("Balance");

            // Relationships
            this.HasRequired(t => t.Agency)
                .WithMany(t => t.Accounts)
                .HasForeignKey(d => d.AgencyId);

        }
    }
}
