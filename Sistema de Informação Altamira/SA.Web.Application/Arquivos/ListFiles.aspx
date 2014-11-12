<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="ListFiles.aspx.cs" Inherits="WebApplication1._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        #File1
        {
            margin-bottom: 0px;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

<p>&nbsp;</p>
    <p>
        <asp:FileUpload ID="fileImagemParaGravar" runat="server"></asp:FileUpload><br />
        <asp:Button ID="Button1" runat="server" Text="Button" onclick="Enviar_Click" />
        <asp:Button ID="Button2" runat="server" onclick="Mensagem_Click" 
            Text="Button" />
        <asp:Label ID="Label1" runat="server" Text="Arquivo invalido !!!!" 
            Visible="False"></asp:Label>
    </p>
    <asp:GridView ID="dgImagens" runat="server" 
            AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" 
            GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="CaDoc0Cod" HeaderText="Codigo" />
            <asp:BoundField DataField="CaDoc0Nom" HeaderText="Nome" />
            <asp:HyperLinkField DataNavigateUrlFields="CaDoc0Cod" 
                DataNavigateUrlFormatString="exibir_imagem.aspx?ImagemID={0}" 
                Text="Ver Arquivo" HeaderImageUrl="~/Images/ico/Download.ico" 
                Target="_blank" />
            <asp:ImageField DataAlternateTextField="CaDoc0Cod" 
                DataAlternateTextFormatString="exibir_imagem.aspx?ImagemID={0}" 
                HeaderText="Arquivo">
            </asp:ImageField>
            <asp:ButtonField ButtonType="Image" DataTextField="CaDoc0Cod" 
                DataTextFormatString="exibir_imagem.aspx?ImagemID={0}" HeaderText="Arquivo" 
                ImageUrl="~/Images/ico/load.ico" Text="Baixar arquivo">
            <ControlStyle Height="36px" Width="36px" />
            </asp:ButtonField>
        </Columns>
        <EditRowStyle BackColor="#2461BF" />
        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#EFF3FB" />
        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#F5F7FB" />
        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
        <SortedDescendingCellStyle BackColor="#E9EBEF" />
        <SortedDescendingHeaderStyle BackColor="#4870BE" />
        </asp:GridView>
        <p>Read more: <a href="http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239GVPmYA">http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239GVPmYA</a> </p>
</asp:Content>
