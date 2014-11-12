<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EnviaSenha.aspx.cs" Inherits="ALTANet.EnviaSenha" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <table style="width:100%;">
        <tr>
            <td align="center" colspan="2" 
                style="font-size: medium; font-weight: bold; font-family: Arial, Helvetica, sans-serif; color: #000080">
                Reenvio de Senha</td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <asp:Label ID="MensagemLabel" runat="server" Font-Bold="True" 
                    Font-Size="Medium" ForeColor="Red"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="right" width="50%">
                Código do Representante (3 digitos):</td>
            <td width="50%">
                <asp:TextBox ID="CodigoTextBox" runat="server" Width="44px" 
                    Font-Size="Medium" ForeColor="#003399" MaxLength="3"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right" width="50%">
                Endereço de Email: 
            </td>
            <td width="50%"><asp:TextBox ID="EmailTextBox" runat="server" Width="240px" 
                    Font-Size="Medium" ForeColor="#003399"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="center" colspan="2" style="width: 100%" width="50%">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <table>
                    <tr><td align="center"><asp:ImageButton ID="EnviarButtom" runat="server" 
                            ImageUrl="~/Images/png/Select_2_32x32x32.png" 
                            onclick="RedefineSenhaButtom_Click" /></td></tr>
                    <tr><td>Reenviar Senha</td></tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
</asp:Content>
