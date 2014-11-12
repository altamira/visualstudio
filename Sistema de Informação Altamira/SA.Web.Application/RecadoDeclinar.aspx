<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecadoDeclinar.aspx.cs" Inherits="SA.Web.Application.RecadoDeclinar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">

        .style1
        {
            width: 729px;
        }
        .style2
        {
            width: 201px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <table width="97%" align="center">
    <tr>
        <td align="center" 
            style="font-size: medium; font-weight: bold; font-family: Arial, Helvetica, sans-serif; color: #000080">
            <table style="width:100%;">
                <tr>
                    <td align="left" class="style1" >
                        <table style="width:100%;">
                            <tr>
                                <td class="style2">
                                    Número do Recado</td>
                                <td>
                                    <asp:Label ID="NumeroLabel" runat="server" Font-Bold="True" 
                            Font-Size="Medium" ForeColor="#3366CC"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2">
                                    Data do Recado</td>
                                <td>
                                    <asp:Label ID="DataLabel" runat="server" Font-Bold="True" 
                            Font-Size="Medium" ForeColor="#3366CC"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2">
                                    Nome do Cliente</td>
                                <td>
                                    <asp:Label ID="ClienteLabel" runat="server" Font-Bold="True" 
                            Font-Size="Medium" ForeColor="#3366CC"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td align="right">
                        <table>
                            <tr>
                                <td align="center">
                                    <asp:ImageButton ID="GravarButtom" runat="server" ImageUrl="~/Images/png/Select_2_32x32x32.png" onclick="GravarButtom_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="0">
                                    <asp:Label ID="GravarLabel" runat="server" Text="Declinar Recado" 
                                        Font-Size="Smaller"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <asp:Label ID="MensagemLabel" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            &nbsp;</td>
    </tr>
    <tr>
        <td valign="top" align="center">
                <asp:Label ID="TituloLabel" runat="server" Font-Bold="True" Font-Size="Medium" 
                    ForeColor="#3366CC"></asp:Label>
            </td>
    </tr>
    <tr>
        <td>
            Motivo:</td>
    </tr>
    <tr>
        <td align="left" valign="top">
            <asp:TextBox ID="ObservacoesTextBox" runat="server" Height="183px" 
                TextMode="MultiLine" Width="95%"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top">
            &nbsp;</td>
    </tr>
</table>
</asp:Content>
