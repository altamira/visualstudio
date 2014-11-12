
namespace Model
{
    public partial class Message
    {
        public int Id { get; set; }
        public string MessageId { get; set; }
        public System.DateTime Sent { get; set; }
        public System.DateTime Received { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string Bcc { get; set; }
        public string ReplyTo { get; set; }
        public string InReplyTo { get; set; }
        public string ReturnPath { get; set; }
        public string Subject { get; set; }
        public byte[] Body { get; set; }
    }
}
