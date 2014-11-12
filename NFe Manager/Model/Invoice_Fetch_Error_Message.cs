
namespace Model
{
    public partial class Invoice_Fetch_Error_Message
    {
        public int Id { get; set; }
        public System.DateTime Sent { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string Bcc { get; set; }
        public string Subject { get; set; }
        public byte[] Body { get; set; }
    }
}
