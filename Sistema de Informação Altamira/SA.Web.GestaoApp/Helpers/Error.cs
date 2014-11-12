
namespace GestaoApp.Helpers
{
    public class Error
    {
        public int Id { get; set; }
        public string Message { get; set; }
        public string Detail { get; set; }

        public Error()
        {
            Id = 0;
            Message = "";
            Detail = "";
        }
    }

    public class Message
    {
        public int Id { get; set; }
        public string Detail { get; set; }

        public Message()
        {
            Id = 0;
            Detail = "";
        }
    }
}
