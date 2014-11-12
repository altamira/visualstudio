<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Acesso.aspx.cs" Inherits="ALTANet.Acesso" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Controle de Acesso</title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Form1" runat="server">
    <div class="header">
        <div class="title">
            <h1>
                Altamira - Gestão de Vendas
            </h1>
        </div>
        <%--<div class="loginDisplay">
            <asp:LoginView ID="HeadLoginView" runat="server" EnableViewState="false">
                <AnonymousTemplate>
                    [ <a href="~/Acesso.aspx" ID="HeadLoginStatus" runat="server">Acessar</a> ]
                </AnonymousTemplate>
                <LoggedInTemplate>
                    Welcome <span class="bold"><asp:LoginName ID="HeadLoginName" runat="server" /></span>!
                    [ <asp:LoginStatus ID="HeadLoginStatus" runat="server" LogoutAction="Redirect" LogoutText="Sair" LogoutPageUrl="~/"/> ]
                </LoggedInTemplate>
            </asp:LoginView>
        </div>--%>
        <div class="clear hideSkiplink">
        </div>
    </div>
    <div class="main" align="center" style="background-color: #FFFFFF">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:Login ID="Login" runat="server" BackColor="#F7F6F3" BorderColor="#E6E2D8" 
            BorderPadding="4" BorderStyle="Solid" BorderWidth="1px" 
            DestinationPageUrl="~/Default.aspx" DisplayRememberMe="False" 
            FailureText="Código ou senha inválido !" Font-Names="Verdana" Font-Size="Medium" 
            ForeColor="#003399" Height="155px" 
            LoginButtonImageUrl="~/Images/png/Action-lock_5_48x48x32.png" 
            LoginButtonText="Controle de Acesso" LoginButtonType="Image" 
            onauthenticate="Authenticate" PasswordLabelText="Senha de Acesso:" 
            PasswordRequiredErrorMessage="Senha obrigatória" 
            RememberMeText=" Lembrar a senha no próximo acesso." 
            TitleText="Controle de Acesso" UserNameLabelText="Código do Representante:" 
            UserNameRequiredErrorMessage="Código do Representante é obrigatório" 
            Width="681px" PasswordRecoveryText="Para cadastrar uma senha ou reenviar, caso tenha esquecido, clique aqui" 
            PasswordRecoveryUrl="~/EnviaSenha.aspx" RememberMeSet="True">
            <InstructionTextStyle Font-Italic="True" ForeColor="Black" Font-Size="Medium" />
            <LabelStyle Font-Bold="True" Font-Size="Medium" />
            <FailureTextStyle Font-Bold="True" Font-Size="Medium" />
            <LoginButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" BorderStyle="Solid" 
                BorderWidth="1px" Font-Names="Verdana" Font-Size="0.8em" ForeColor="#284775" />
            <TextBoxStyle BackColor="White" BorderStyle="Solid" BorderWidth="1px" 
                Font-Size="Medium" ForeColor="#3366CC" Font-Bold="True" />
            <TitleTextStyle BackColor="#5D7B9D" Font-Bold="True" Font-Size="Large" 
                ForeColor="White" />
            <ValidatorTextStyle Font-Bold="True" Font-Size="Medium" />
        </asp:Login>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
    </div>
    <div class="clear">
    </div>
    </form>
</body>
</html>
