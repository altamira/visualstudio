<%@ Page Title="Orçamento" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Orcamento.aspx.cs" Inherits="WebApplication1.orcamento" %>
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
                <asp:Label ID="TituloLabel" runat="server" Font-Bold="True" Font-Size="Medium" 
                    ForeColor="#3366CC"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>

    <asp:DetailsView ID="OrcamentoFormView" runat="server" AutoGenerateRows="False" 
        Height="50px" Width="100%" BackColor="White" BorderColor="#CCCCCC" 
    BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" 
    GridLines="Horizontal" 
        CaptionAlign="Top">
        <EditRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
        <Fields>
            <asp:BoundField DataField="Número" HeaderText="Número do Orçamento" >
            <ItemStyle Font-Bold="True" Font-Size="Medium" />
            </asp:BoundField>
            <asp:BoundField DataField="Revisão" HeaderText="Revisão" >
            <ItemStyle Font-Bold="True" Font-Size="Medium" />
            </asp:BoundField>
            <asp:HyperLinkField DataNavigateUrlFields="Número do Pedido de Venda" 
                DataNavigateUrlFormatString="pedido.aspx?{0}" 
                DataTextField="Número do Pedido de Venda" 
                HeaderText="Número do Pedido de Venda">
            <ItemStyle Font-Bold="True" Font-Size="Medium" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="Data do Cadastro" DataFormatString="{0:d}" 
                HeaderText="Data do Cadastro" />
            <asp:BoundField DataField="Nome Fantasia" HeaderText="Nome Fantasia" />
            <asp:BoundField DataField="Razão Social" HeaderText="Razão Social" />
            <asp:BoundField DataField="Logradouro" HeaderText="Logradouro" />
            <asp:BoundField DataField="Endereço" HeaderText="Endereço" />
            <asp:BoundField DataField="Número do Endereço" HeaderText="Número" />
            <asp:BoundField DataField="Complemento do Endereço" HeaderText="Complemento" />
            <asp:BoundField DataField="Bairro" HeaderText="Bairro" />
            <asp:BoundField DataField="CEP" HeaderText="CEP" />
            <asp:BoundField DataField="Cidade" HeaderText="Cidade" />
            <asp:BoundField DataField="Estado" HeaderText="Estado" />
            <asp:BoundField DataField="Nome do Contato" HeaderText="Nome do Contato" />
            <asp:BoundField DataField="Departamento do Contato" 
                HeaderText="Departamento do Contato" />
            <asp:BoundField DataField="DDD do Telefone" HeaderText="DDD do Telefone" />
            <asp:BoundField DataField="Telefone" HeaderText="Telefone" />
            <asp:BoundField DataField="Ramal do Telefone" HeaderText="Ramal do Telefone" />
            <asp:BoundField DataField="DDD do Fax" HeaderText="DDD do Fax" />
            <asp:BoundField DataField="Fax" HeaderText="Fax" />
            <asp:BoundField DataField="Ramal do Fax" HeaderText="Ramal do Fax" />
            <asp:BoundField DataField="Email" 
                DataFormatString="&lt;a href=mailto:{0}&gt;{0}&lt;/a&gt;" HeaderText="Email" 
                HtmlEncodeFormatString="False" />
            <asp:BoundField DataField="Código do Representante" 
                HeaderText="Código do Representante" Visible="False" />
            <asp:BoundField DataField="Nome do Representante" 
                HeaderText="Nome do Representante" Visible="False" />
            <asp:BoundField DataField="Situação Atual" HeaderText="Situação Atual" />
        </Fields>
        <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
        <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
    </asp:DetailsView>
    <asp:GridView ID="ItemOrcamentoGridView" runat="server" 
    AutoGenerateColumns="False" CellPadding="4" GridLines="None" 
    Width="100%" ForeColor="#333333">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:BoundField DataField="Item" HeaderText="Item">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
            </asp:BoundField>
            <asp:BoundField DataField="Código do Produto" HeaderText="Código">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
            </asp:BoundField>
            <asp:BoundField DataField="Descrição" HeaderText="Descrição">
            <ItemStyle VerticalAlign="Top" />
            </asp:BoundField>
            <asp:BoundField DataField="Quantidade" HeaderText="Quantidade">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Aliquota do IPI" DataFormatString="{0:p}" 
                HeaderText=" IPI">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Aliquota do ICMS" DataFormatString="{0:p}" 
                HeaderText="ICMS">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Preço Unitário" DataFormatString="{0:c}" 
                HeaderText="Unitário">
            <ItemStyle HorizontalAlign="Right" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Total do Produto" DataFormatString="{0:c}" 
                HeaderText="Total">
            <ItemStyle HorizontalAlign="Right" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
        </Columns>
        <EditRowStyle BackColor="#999999" />
        <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#E9E7E2" />
        <SortedAscendingHeaderStyle BackColor="#506C8C" />
        <SortedDescendingCellStyle BackColor="#FFFDF8" />
        <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
    </asp:GridView>
</asp:Content>
