using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;

namespace SilverlightGridPrinting.Web
{
    public partial class PrintHandler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["fn"] != null)
            {
                File.WriteAllText(Server.MapPath(Request.QueryString["fn"]),
                    new StreamReader(Request.InputStream).ReadToEnd(), Encoding.UTF8);
            }
        }
    }
}
