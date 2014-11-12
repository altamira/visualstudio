<%@ Page Title="Acompanhamento de Orçamento" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Acompanhamento.aspx.cs" Inherits="SA.Web.Application.Acompanhamento" %>
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
    <form method="post">
    <table width="97%" align="center">
    <tr>
        <td align="center" colspan="2" style="font-size: medium; font-weight: bold; font-family: Arial, Helvetica, sans-serif; color: #000080">
            <table style="width:100%;">
                <tr>
                    <td align="left" class="style1" >
                        <table style="width:100%;">
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
                        </table>
                    </td>
                    <td align="right">
                        <table>
                            <tr><td align="center"><asp:ImageButton ID="GravarButtom" runat="server" ImageUrl="~/Images/png/Select_2_32x32x32.png" onclick="GravarButtom_Click" /></td></tr>
                            <tr><td rowspan="0"><asp:Label ID="GravarLabel" runat="server" Text="Gravar Situação" Font-Size="Smaller"></asp:Label></td></tr>
                        </table>
                        <asp:Label ID="MensagemLabel" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                </table>
        </td>
    </tr>
    <tr>
        <td width="50%">Qual a Situação do Orçamento:</td>
        <td width="50%">Qual o Tipo de Material deste Orçamento:</td>
    </tr>
    <tr>
        <td align="left" valign="top">
            <asp:RadioButtonList ID="SituacaoRadioButtonList" runat="server" 
                CssClass="checkBoxListWrap" Font-Bold="True" Font-Size="Medium" Height="17px" 
                RepeatColumns="2" RepeatDirection="Horizontal" Width="100%">
                <asp:ListItem Enabled="False">Em Projeto</asp:ListItem>
                <asp:ListItem Enabled="False">Ficha Financeira</asp:ListItem>
                <asp:ListItem Enabled="False">Pendente</asp:ListItem>
                <asp:ListItem>Em Andamento</asp:ListItem>
                <asp:ListItem>Suspenso</asp:ListItem>
                <asp:ListItem>Fechado</asp:ListItem>
                <asp:ListItem>Perdido</asp:ListItem>
                <asp:ListItem>Cancelado</asp:ListItem>
            </asp:RadioButtonList>
        </td>
        <td>
            <table style="width:100%;">
                <tr>
                    <td colspan="2" valign="top">
                        <asp:CheckBoxList ID="TipoMaterialCheckBoxList" runat="server" CellPadding="5" 
                            CellSpacing="5" CssClass="checkBoxListWrap" RepeatColumns="4" 
                            RepeatDirection="Horizontal" Width="100%" Font-Bold="True" 
                            Font-Size="Medium">
                            <asp:ListItem>Estante</asp:ListItem>
                            <asp:ListItem>Porta Palete</asp:ListItem>
                            <asp:ListItem>Mezanino</asp:ListItem>
                            <asp:ListItem>Painel</asp:ListItem>
                            <asp:ListItem>Divisória</asp:ListItem>
                            <asp:ListItem>Piso</asp:ListItem>
                            <asp:ListItem>Resindek</asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td>Outros</td>
                    <td><asp:TextBox ID="TipoMaterialTextBox" runat="server" MaxLength="50" Width="189px"></asp:TextBox></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left">Qual a Possibilidade de Fechar:</td>
        <td>Com quem a Altamira esta Concorrendo neste Orçamento:</td>
    </tr>
    <tr>
        <td valign="top">
            <asp:RadioButtonList ID="ProbabilidadeRabioButtonList" runat="server" 
                CssClass="checkBoxListWrap" RepeatColumns="6" RepeatDirection="Horizontal" 
                Font-Bold="True" Font-Size="Medium" Width="100%">
                <asp:ListItem Value="0">0%</asp:ListItem>
                <asp:ListItem Value="10">10%</asp:ListItem>
                <asp:ListItem Value="20">20%</asp:ListItem>
                <asp:ListItem Value="30">30%</asp:ListItem>
                <asp:ListItem Value="40">40%</asp:ListItem>
                <asp:ListItem Value="50">50%</asp:ListItem>
                <asp:ListItem Value="60">60%</asp:ListItem>
                <asp:ListItem Value="70">70%</asp:ListItem>
                <asp:ListItem Value="80">80%</asp:ListItem>
                <asp:ListItem Value="90">90%</asp:ListItem>
                <asp:ListItem Value="100">100%</asp:ListItem>
            </asp:RadioButtonList>
        </td>
        <td valign="top">
            <table style="width:100%;">
                <tr>
                    <td align="left" colspan="2">
                        <asp:CheckBoxList ID="ConcorrentesCheckBoxList" runat="server" 
                            CssClass="checkBoxListWrap" RepeatColumns="3" RepeatDirection="Horizontal" 
                            Width="100%" Font-Bold="True" Font-Size="Medium">
                            <asp:ListItem>Mecalux</asp:ListItem>
                            <asp:ListItem>Isma</asp:ListItem>
                            <asp:ListItem>Aguia</asp:ListItem>
                            <asp:ListItem>Montia&#231;o</asp:ListItem>
                            <asp:ListItem>MetalShop</asp:ListItem>
                            <asp:ListItem>Longa</asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td>Outros</td>
                    <td><asp:TextBox ID="ConcorrentesTextBox" runat="server" MaxLength="50" Width="190px"></asp:TextBox></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>A Data do Próximo Contato:</td>
        <td>Outras Informações/Observações:</td>
    </tr>
    <tr>
        <td align="left" valign="top">
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
        <td align="left" valign="top">
            <asp:TextBox ID="ObservacoesTextBox" runat="server" Height="183px" 
                TextMode="MultiLine" Width="95%"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top" align="center" colspan="2"><strong>Histórico das Atualizações</strong></td>
    </tr>
    <tr>
        <td valign="top" colspan="2">
            <asp:GridView ID="HistoricoGridView" runat="server" AutoGenerateColumns="False" Width="100%">
                <Columns>
                    <asp:BoundField DataField="Número do Orçamento" 
                        HeaderText="Número do Orçamento" Visible="False">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Última Atualização" 
                        DataFormatString="{0:dd/MM/yyyy hh:mm}" HeaderText="Última Atualização">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Situação" HeaderText="Situação">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Observações" HeaderText="Observações">
                    <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td valign="top" colspan="2">&nbsp;</td>
    </tr>
    </table>
</form>
</asp:Content>
