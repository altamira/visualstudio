using System;
using System.Web.UI;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using ALTANet.Lib;

namespace ALTANet
{
    public partial class EnviaSenha : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RedefineSenhaButtom_Click(object sender, ImageClickEventArgs e)
        {
            MailAddress email;
            int Codigo = 0;

            try
            {
                email = new MailAddress(EmailTextBox.Text.Trim());
            }
            catch (Exception)
            {
                MensagemLabel.Text = "Endereço de email inválido !";
                return;
            }


            if (!int.TryParse(CodigoTextBox.Text.Trim(), out Codigo))
            {
                MensagemLabel.Text = "Código do Representante inválido !";
                return;
            }

            int NovaSenha = 0;
            NovaSenha = DateTime.Now.GetHashCode();
            NovaSenha = Math.Abs(NovaSenha);

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Redefine e Envia a Senha do Representante]";

            Command.Parameters.Add(new SqlParameter("@Representante", SqlDbType.Char, 3)).Value = CodigoTextBox.Text.Trim();
            Command.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 100)).Value = email.Address.Trim();
            Command.Parameters.Add(new SqlParameter("@NovaSenha", SqlDbType.NVarChar, 40)).Value = NovaSenha.ToString().Trim();
            Command.Parameters.Add(new SqlParameter("@NovaSenhaCriptografada", SqlDbType.NVarChar, 40)).Value = Security.GetSHA1Hash(NovaSenha.ToString());

            try
            {
                SqlDataReader DataReader = Command.ExecuteReader();

                if (DataReader.Read())
                {
                    MensagemLabel.Text = DataReader["Mensagem"].ToString();
                }
                else
                {
                    MensagemLabel.Text = "Erro ao enviar a senha, entre em contato com o suporte técnico da Altamira.";
                }

                DataReader.Close();
            }
            catch (Exception ex)
            {
                MensagemLabel.Text = ex.Message.ToString();
            }

            Connection.Close();
        }

        protected void EnviarButtom_Click(object sender, ImageClickEventArgs e)
        {
            //crio objeto responsável pela mensagem de email
            MailMessage mail = new MailMessage();

            //rementente do email
            mail.From = new MailAddress("sistemas.ti@altamira.com.br");

            //email para resposta(quando o destinatário receber e clicar em responder, vai para:)
            mail.ReplyToList.Add("sistemas.ti@altamira.com.br");

            //destinatário(s) do email(s). Obs. pode ser mais de um, pra isso basta repetir a linha
            //abaixo com outro endereço
            try
            {
                mail.To.Add(EmailTextBox.Text);
            }
            catch (Exception)
            {
                MensagemLabel.Text = "Endereço de email inválido, verifique !";
                return;
            }

            int NovaSenha = 0;
            NovaSenha = DateTime.Now.GetHashCode();

            //se quiser enviar uma cópia oculta pra alguém, utilize a linha abaixo:
            mail.Bcc.Add("sistemas.ti@altamira.com.br");

            //prioridade do email
            mail.Priority = MailPriority.Normal;

            //utilize true pra ativar html no conteúdo do email, ou false, para somente texto
            mail.IsBodyHtml = true;

            //Assunto do email
            mail.Subject = "Altamira - Gestão de Vendas - Reenvio de Senha";

            //corpo do email a ser enviado
            mail.Body = "Conforme solicitado segue a nova senha:<BR><BR>Nova Senha: <b>" + NovaSenha.ToString() + "</b><BR><BR>Em caso de dúvida favor entrar em contato com o suporte da Altamira <mailto:sistemas.ti@altamira.com.br>sistemas.ti@altamira.com.br</a><BR><BR>";

            //codificação do assunto do email para que os caracteres acentuados serem reconhecidos.
            mail.SubjectEncoding = Encoding.GetEncoding("ISO-8859-1");

            //codificação do corpo do emailpara que os caracteres acentuados serem reconhecidos.
            mail.BodyEncoding = Encoding.GetEncoding("ISO-8859-1");

            //cria o objeto responsável pelo envio do email
            SmtpClient smtp = new SmtpClient();

            //endereço do servidor SMTP(para mais detalhes leia abaixo do código)
            smtp.Host = "mail.altamira.com.br";

            //para envio de email autenticado, coloque login e senha de seu servidor de email
            //para detalhes leia abaixo do código
            smtp.Credentials = new NetworkCredential("gerencia.ti@altamira.com.br", "3p7aR43b19x");

            //envia o email
            try
            {
                smtp.Send(mail);
                MensagemLabel.Text = "Senha enviada com sucesso !";


            }
            catch (Exception ex)
            {
                MensagemLabel.Text = ex.Message;
            }

        }

    }
}