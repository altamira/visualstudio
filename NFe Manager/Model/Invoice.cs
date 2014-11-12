
namespace Model
{
    public enum Status : short
    {
        New,
        Accepted,
        Rejected,
        Divergent,
        Received,
        Exception
    }

    public enum Type : short
    {
        Other,
        NFe,
        CTe,
        NFSe
    }

    public partial class Invoice
    {
        public int Id { get; set; }
        public System.DateTime Date { get; set; }
        public int Number { get; set; }
        public decimal Value { get; set; }
        public string Sender { get; set; }
        public string Receipt { get; set; }
        public string Key { get; set; }
        public Type Type { get; set; }
        public Status Status { get; set; }
        public byte[] Hash { get; set; }
        public string Xml { get; set; }
    }
}
