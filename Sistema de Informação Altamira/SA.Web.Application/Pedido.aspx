<%@ Page Title="Pedido" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Pedido.aspx.cs" Inherits="WebApplication1.pedido" %>
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
            <td align="center">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
    <asp:DetailsView ID="PedidoFormView" runat="server" Height="50px" Width="100%" 
        AutoGenerateRows="False" BackColor="White" BorderColor="#CCCCCC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" 
        GridLines="Horizontal">
        <EditRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
        <Fields>
            <asp:BoundField DataField="Número" HeaderText="Número do Pedido" >
            <ItemStyle Font-Bold="True" Font-Size="Medium" />
            </asp:BoundField>
            <asp:HyperLinkField DataNavigateUrlFields="Número do Orçamento" 
                DataNavigateUrlFormatString="orcamento.aspx?{0}" 
                DataTextField="Número do Orçamento" HeaderText="Número do Orçamento">
            <ItemStyle Font-Bold="True" Font-Size="Medium" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="Data da Emissão" DataFormatString="{0:d}" 
                HeaderText="Data da Emissão" />
            <asp:BoundField DataField="Data da Entrega" DataFormatString="{0:d}" 
                HeaderText="Data da Entrega" />
            <asp:BoundField DataField="Nome Fantasia" HeaderText="Nome Fantasia" />
            <asp:BoundField DataField="Razão Social" HeaderText="Razão Social" />
            <asp:BoundField DataField="Código da Condição de Pagamento" 
                HeaderText="Código da Condição de Pagamento" />
            <asp:BoundField DataField="Código do Representante" 
                HeaderText="Código do Representante" />
            <asp:BoundField DataField="Total dos Produtos" DataFormatString="{0:c}" 
                HeaderText="Total dos Produtos" />
            <asp:BoundField DataField="Percentual de Comissão" DataFormatString="{0:p}" 
                HeaderText="Percentual de Comissão" />
            <asp:BoundField DataField="Valor da Comissão" DataFormatString="{0:c}" 
                HeaderText="Valor da Comissão" />
            <asp:BoundField DataField="Total do IPI" DataFormatString="{0:c}" 
                HeaderText="Total do IPI" />
            <asp:BoundField DataField="Total do Pedido" DataFormatString="{0:c}" 
                HeaderText="Total do Pedido" />
        </Fields>
        <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
        <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
    </asp:DetailsView>
            </td>
        </tr>
        <tr>
            <td align="center">
                Itens do Pedido de Venda</td>
        </tr>
        <tr>
            <td>
    <asp:GridView ID="ItemPedidoGridView" runat="server" 
        AutoGenerateColumns="False" CellPadding="4" GridLines="None" 
        Width="100%" ForeColor="#333333">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:BoundField DataField="Data de Entrega" DataFormatString="{0:d}" 
                HeaderText="Data de Entrega">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Código do Produto" HeaderText="Código" 
                Visible="False">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Descrição" HeaderText="Descrição">
            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Descrição Detalhada" 
                HeaderText="Descrição Detalhada">
            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" />
            </asp:BoundField>
            <asp:BoundField DataField="Quantidade" HeaderText="Quantidade">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Cor" HeaderText="Cor">
            <ItemStyle Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Aliquota de IPI" DataFormatString="{0:p}" 
                HeaderText="Aliquota de IPI">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Valor do IPI" DataFormatString="{0:c}" 
                HeaderText="Valor do IPI">
            <ItemStyle HorizontalAlign="Right" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Preço Unitário" DataFormatString="{0:c}" 
                HeaderText="Unitário">
            <ItemStyle HorizontalAlign="Right" VerticalAlign="Top" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Valor do Item" DataFormatString="{0:c}" 
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
            </td>
        </tr>
    </table>
</asp:Content>
