<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Agenda.aspx.cs" Inherits="ALTANet.Agenda" %>
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
    .style3
    {
        width: 116px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <table width="97%" align="center">
    <tr>
        <td align="center" colspan="3" 
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
                                    <asp:Label ID="GravarLabel" runat="server" Text="Gravar Agenda" 
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
        <td width="50%" colspan="3" style="width: 100%">
            Informações do contato:</td>
    </tr>
    <tr>
        <td valign="top" colspan="3">
            <table style="width:100%;">
                <tr>
                    <td>
                        Nome Fantasia</td>
                    <td>
                        <asp:TextBox ID="NomeFantasiaTextBox" runat="server" MaxLength="40"></asp:TextBox>
                    </td>
                    <td>
                        Razão Social</td>
                    <td>
                        <asp:TextBox ID="RazaoSocialTextBox" runat="server" MaxLength="50"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Endereço</td>
                    <td>
                        <asp:TextBox ID="EnderecoTextBox" runat="server" MaxLength="50"></asp:TextBox>
                    </td>
                    <td>
                        Número</td>
                    <td>
                        <asp:TextBox ID="NumeroTextBox" runat="server" MaxLength="20"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Complemento</td>
                    <td>
                        <asp:TextBox ID="ComplementoTextBox" runat="server" MaxLength="10"></asp:TextBox>
                    </td>
                    <td>
                        Bairro</td>
                    <td>
                        <asp:TextBox ID="BairroTextBox" runat="server" MaxLength="30"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Cidade</td>
                    <td>
                        <asp:TextBox ID="CidadeTextBox" runat="server" MaxLength="50"></asp:TextBox>
                    </td>
                    <td>
                        Estado</td>
                    <td>
                        <asp:DropDownList ID="EstadoDropDownList" runat="server">
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
                        <asp:TextBox ID="ContatoTextBox" runat="server" MaxLength="30"></asp:TextBox>
                    </td>
                    <td>
                        Departamento</td>
                    <td>
                        <asp:TextBox ID="DepartamentoTextBox" runat="server" MaxLength="30"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Telefone</td>
                    <td>
                        <asp:TextBox ID="DDDTelefoneTextBox" runat="server" MaxLength="2" Width="23px"></asp:TextBox>
                        <asp:TextBox ID="TelefoneTextBox" runat="server" MaxLength="10" Width="79px"></asp:TextBox>
                        <asp:TextBox ID="TelefoneRamalTextBox" runat="server" MaxLength="5" 
                            Width="36px"></asp:TextBox>
                    </td>
                    <td>
                        Celular</td>
                    <td>
                        <asp:TextBox ID="DDDCelularTextBox" runat="server" MaxLength="2" Width="23px"></asp:TextBox>
                        <asp:TextBox ID="CelularTextBox" runat="server" MaxLength="10" Width="79px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Email</td>
                    <td colspan="3">
                        <asp:TextBox ID="EmailTextBox" runat="server" MaxLength="100" Width="444px"></asp:TextBox>
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
            </table>
            </td>
    </tr>
    <tr>
        <td class="style3">
            Data da Visita:</td>
        <td class="style3">
            Horário:</td>
        <td>
            Observações:</td>
    </tr>
    <tr>
        <td align="left" valign="top" class="style3" width="50%">
            <asp:Calendar ID="ProximoContatoCalendar" runat="server" BackColor="White" 
                    BorderColor="White" BorderWidth="1px" Font-Names="Verdana" Font-Size="9pt" 
                    ForeColor="Black" Height="190px" NextPrevFormat="FullMonth" Width="350px">
                <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
                <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" 
                    VerticalAlign="Bottom" />
                <OtherMonthDayStyle ForeColor="#999999" />
                <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px" 
                    Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
                <TodayDayStyle BackColor="#CCCCCC" />
            </asp:Calendar>
        </td>
        <td align="left" valign="middle" class="style3" width="50%">
            <table style="width:100%;">
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <strong>Hora</strong></td>
                    <td>
                        <asp:DropDownList ID="HoraDropDownList" runat="server">
                            <asp:ListItem>07</asp:ListItem>
                            <asp:ListItem>08</asp:ListItem>
                            <asp:ListItem>09</asp:ListItem>
                            <asp:ListItem>10</asp:ListItem>
                            <asp:ListItem>11</asp:ListItem>
                            <asp:ListItem>12</asp:ListItem>
                            <asp:ListItem>13</asp:ListItem>
                            <asp:ListItem>14</asp:ListItem>
                            <asp:ListItem>15</asp:ListItem>
                            <asp:ListItem>16</asp:ListItem>
                            <asp:ListItem>17</asp:ListItem>
                            <asp:ListItem>18</asp:ListItem>
                            <asp:ListItem>19</asp:ListItem>
                            <asp:ListItem>20</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <strong>Minuto</strong></td>
                    <td>
                        <asp:DropDownList ID="MinutoDropDownList" runat="server">
                            <asp:ListItem>00</asp:ListItem>
                            <asp:ListItem>15</asp:ListItem>
                            <asp:ListItem>30</asp:ListItem>
                            <asp:ListItem>45</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </td>
        <td align="left" valign="top" width="50%">
            <asp:TextBox ID="ObservacoesTextBox" runat="server" Height="183px" 
                TextMode="MultiLine" Width="95%"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top" colspan="3">
            &nbsp;</td>
    </tr>
</table>
</asp:Content>
