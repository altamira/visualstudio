<%@ Page Title="Recado" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Recado.aspx.cs" Inherits="WebApplication1.recado" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <table style="width:100%;">
        <tr>
            <td align="center">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="center">
                <asp:Label ID="TituloLabel" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="#3366CC"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="center">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:DetailsView ID="RecadoFormView" runat="server" Height="50px" Width="100%" 
                                BackColor="White" BorderColor="#CCCCCC" 
                    BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" 
                    GridLines="Horizontal">
                    <EditRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
                </asp:DetailsView>
            </td>
        </tr>
        </table>
</asp:Content>
