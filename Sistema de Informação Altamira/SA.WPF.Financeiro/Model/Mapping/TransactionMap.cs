using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using SA.WPF.Financial.Enum;

namespace SA.WPF.Financial.Model.Mapping
{
    public class TransactionMap : EntityTypeConfiguration<Transaction>
    {
        public TransactionMap()
        {
            // Primary Key
            this.HasKey(t => t.Id);

            // Properties
            this.Property(t => t.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.TRANSACTIONTYPE)
                .IsRequired();

            // Table & Column Mappings
            this.ToTable("Transaction", "Financial");
            this.Property(t => t.Id).HasColumnName("Id");
            this.Property(t => t.AccountId).HasColumnName("Account");
            this.Property(t => t.Data).HasColumnName("Date");
            this.Property(t => t.Cheque).HasColumnName("Check");
            this.Property(t => t.Descricao).HasColumnName("Description");
            this.Property(t => t.Valor).HasColumnName("Value");
            this.Property(t => t.Type).HasColumnName("Type");
            this.Property(t => t.Liquidated).HasColumnName("Liquidated");

            // Relationships
            this.HasRequired(t => t.Account)
                .WithMany(t => t.Transactions)
                .HasForeignKey(d => d.AccountId);

        }
    }
}
