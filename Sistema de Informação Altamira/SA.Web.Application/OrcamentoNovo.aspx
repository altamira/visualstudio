<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrcamentoNovo.aspx.cs" Inherits="SA.Web.Application.OrcamentoNovo" %>
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
                <table style="width:100%;">
                    <tr>
                        <td>
                            CNPJ</td>
                        <td>
                            <asp:TextBox ID="TextBox13" runat="server" MaxLength="18"></asp:TextBox>
                        </td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            Nome Fantasia</td>
                        <td>
                            <asp:TextBox ID="TextBox1" runat="server" MaxLength="40"></asp:TextBox>
                        </td>
                        <td>
                            Razão Social</td>
                        <td>
                            <asp:TextBox ID="TextBox2" runat="server" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Endereço</td>
                        <td>
                            <asp:TextBox ID="TextBox3" runat="server" MaxLength="50"></asp:TextBox>
                        </td>
                        <td>
                            Número</td>
                        <td>
                            <asp:TextBox ID="TextBox4" runat="server" MaxLength="20"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Complemento</td>
                        <td>
                            <asp:TextBox ID="TextBox5" runat="server" MaxLength="10"></asp:TextBox>
                        </td>
                        <td>
                            Bairro</td>
                        <td>
                            <asp:TextBox ID="TextBox6" runat="server" MaxLength="30"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Cidade</td>
                        <td>
                            <asp:TextBox ID="TextBox7" runat="server" MaxLength="50"></asp:TextBox>
                        </td>
                        <td>
                            Estado</td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server">
                                <asp:ListItem Selected="True" Value="SP">SÃO PAULO</asp:ListItem>
                                <asp:ListItem Value="AC">ACRE</asp:ListItem>
                                <asp:ListItem Value="AL">ALAGOAS</asp:ListItem>
                                <asp:ListItem Value="AM">AMAZONAS</asp:ListItem>
                                <asp:ListItem Value="AP">AMAPA</asp:ListItem>
                                <asp:ListItem Value="BA">BAHIA</asp:ListItem>
                                <asp:ListItem Value="CE">CEARA</asp:ListItem>
                                <asp:ListItem Value="DF">DISTRITO FEDERAL</asp:ListItem>
                                <asp:ListItem Value="ES">ESPIRITO SANTO</asp:ListItem>
                                <asp:ListItem Value="GO">GOIAS</asp:ListItem>
                                <asp:ListItem Value="MA">MARANHAO</asp:ListItem>
                                <asp:ListItem>MATO GROSSO</asp:ListItem>
                                <asp:ListItem Value="MS">MATO GROSSO DO SUL</asp:ListItem>
                                <asp:ListItem Value="MG">MINAS GERAIS</asp:ListItem>
                                <asp:ListItem Value="PA">PARA</asp:ListItem>
                                <asp:ListItem Value="PB">PARAIBA</asp:ListItem>
                                <asp:ListItem Value="PR">PARANA</asp:ListItem>
                                <asp:ListItem Value="PE">PERNAMBUCO</asp:ListItem>
                                <asp:ListItem Value="PI">PIAUI</asp:ListItem>
                                <asp:ListItem>RIO DE JANEIRO</asp:ListItem>
                                <asp:ListItem Value="RN">RIO GRANDE DO NORTE</asp:ListItem>
                                <asp:ListItem Value="RS">RIO GRANDE DO SUL</asp:ListItem>
                                <asp:ListItem Value="RO">RONDONIA</asp:ListItem>
                                <asp:ListItem Value="RR">RORAIMA</asp:ListItem>
                                <asp:ListItem Value="SC">SANTA CATARINA</asp:ListItem>
                                <asp:ListItem Value="SE">SERGIPE</asp:ListItem>
                                <asp:ListItem Value="TO">TOCANTINS</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Nome do Contato</td>
                        <td>
                            <asp:TextBox ID="TextBox8" runat="server" MaxLength="30"></asp:TextBox>
                        </td>
                        <td>
                            Departamento</td>
                        <td>
                            <asp:TextBox ID="TextBox9" runat="server" MaxLength="30"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Telefone</td>
                        <td>
                            <asp:TextBox ID="TextBox10" runat="server" MaxLength="2" Width="23px"></asp:TextBox>
                            <asp:TextBox ID="TextBox18" runat="server" MaxLength="10" Width="79px"></asp:TextBox>
                            <asp:TextBox ID="TextBox14" runat="server" MaxLength="5" Width="36px"></asp:TextBox>
                        </td>
                        <td>
                            Fax</td>
                        <td>
                            <asp:TextBox ID="TextBox19" runat="server" MaxLength="2" Width="23px"></asp:TextBox>
                            <asp:TextBox ID="TextBox20" runat="server" MaxLength="10" Width="79px"></asp:TextBox>
                            <asp:TextBox ID="TextBox21" runat="server" MaxLength="5" Width="36px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Email</td>
                        <td colspan="3">
                            <asp:TextBox ID="TextBox12" runat="server" MaxLength="100" Width="444px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            &nbsp;</td>
                    </tr>
                </table>
        </td>
    </tr>
</table>
</asp:Content>
