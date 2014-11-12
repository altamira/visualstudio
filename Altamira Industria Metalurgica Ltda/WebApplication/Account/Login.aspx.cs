using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace WebApplication1.Account
{
    public partial class Login : System.Web.UI.Page
    {
        int iResult = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register.aspx?ReturnUrl=" + HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            if (iResult > 0)
            {
                FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(iResult.ToString(), false, 15);
                string encryptTicket = FormsAuthentication.Encrypt(authTicket);
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptTicket);
                Response.Cookies.Add(authCookie);
                Session.Add("Session", iResult.ToString());
                FormsAuthentication.RedirectFromLoginPage(iResult.ToString(), false);
            } else {
                LoginUser.UserName = "";
                //LoginUser.Password = "";
                // Text = "Usuário ou Senha incorreta. Tente novamente!"
            }
        }

        protected void LoginUser_Authenticate(object sender, AuthenticateEventArgs e)
        {
            e.Authenticated = true;
            FormsAuthentication.RedirectFromLoginPage(iResult.ToString(), false);
        }
    }
}
