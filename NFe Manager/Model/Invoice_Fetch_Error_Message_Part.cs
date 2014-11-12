
namespace Model
{
    public partial class Invoice_Fetch_Error_Message_Part
    {
        public int Id { get; set; }
        public int Message { get; set; }
        public string ContentType { get; set; }
        public string MessagePart { get; set; }
        public string ExceptionType { get; set; }
        public string Error { get; set; }
    }
}
