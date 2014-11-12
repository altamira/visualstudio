<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SA.Web.Application.Arquivos.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">

        .style2
        {
        }
        .style3
        {
            height: 154px;
        }
        .style4
        {
            font-size: medium;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                        <br />
                        <table style="width:80%;" align="center">
                            <tr>
                                <td class="style4" align="center" colspan="2">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="style2">
                                    Número do Orçamento</td>
                                <td>
                                    <asp:Label ID="NumeroLabel" runat="server" Font-Bold="True" 
                            Font-Size="Medium" ForeColor="#3366CC"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2">
                                    Data do Orçamento</td>
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
                            <tr>
                                <td class="style2" colspan="2">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="style2" align="center" colspan="2">
                                    <strong>
                                    <asp:Label ID="TituloLabel" runat="server" Text="Label"></asp:Label>
                                    </strong></td>
                            </tr>
                            <tr>
                                <td class="style3" colspan="2">
                                    <asp:GridView ID="ArquivosGridView" runat="server" AutoGenerateColumns="False" 
                                        CellPadding="4" ForeColor="#333333" GridLines="None" Width="100%">
                                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                        <Columns>
                                            <asp:HyperLinkField DataNavigateUrlFields="Identificador" 
                                                DataNavigateUrlFormatString="~/Arquivos/Arquivo.aspx?{0}" 
                                                DataTextField="Nome do Arquivo com Extensão" HeaderText="Arquivo">
                                            <ItemStyle Font-Bold="True" Font-Size="Medium" ForeColor="#3366CC" 
                                                HorizontalAlign="Center" VerticalAlign="Top" />
                                            </asp:HyperLinkField>
                                            <asp:BoundField DataField="Pasta Virtual" HeaderText="Pasta">
                                            <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" 
                                                VerticalAlign="Top" Wrap="False" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Tamanho do Arquivo" HeaderText="Tamanho (bytes)">
                                            <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" 
                                                VerticalAlign="Top" Wrap="False" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Data de Criação do Arquivo" DataFormatString="{0:d}" 
                                                HeaderText="Data de Criação">
                                            <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" 
                                                VerticalAlign="Top" Wrap="False" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Data da Última Alteração no Arquivo" 
                                                DataFormatString="{0:d}" HeaderText="Data de Alteração">
                                            <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" 
                                                VerticalAlign="Top" Wrap="False" />
                                            </asp:BoundField>
                                        </Columns>
                                        <EditRowStyle BackColor="#999999" />
                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
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
                    <br />
</asp:Content>
