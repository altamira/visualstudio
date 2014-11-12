using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Sessao"] != null)
            {
                UserName.Text = Session["Nome"].ToString();
                ValidadeLabel.Text = Session["Validade"].ToString();
            }
        }

        protected void HeadLoginStatus_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Session["Sessao"] = null;
            Response.Redirect("/Acesso.aspx");
        }

        protected void LogoutButtom_Click(object sender, ImageClickEventArgs e)
        {
            Session["Sessao"] = null;
            Response.Redirect("/Acesso.aspx");
        }

    }
}
