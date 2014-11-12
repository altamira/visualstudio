<%@ Page Title="Recados" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Recados.aspx.cs" Inherits="WebApplication1.recados" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">


        .style1
        {
            height: 40px;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <table width="100%">
        <tr>
            <td align="center">
                <asp:ImageButton ID="DiaBottom" runat="server" 
                    ImageUrl="~/Images/png/calendar-selection-day_4_48x48x32.png" 
                    onclick="DiaBottom_Click" />
            </td>
            <td align="center">
                <asp:ImageButton ID="SemanaButtom" runat="server" 
                    ImageUrl="~/Images/png/calendar-selection-week_4_48x48x32.png" 
                    onclick="SemanaButtom_Click" />
            </td>
            <td align="center">
                <asp:ImageButton ID="MesButtom" runat="server" 
                    ImageUrl="~/Images/png/calendar-selection-month_4_48x48x32.png" 
                    onclick="MesButtom_Click" />
            </td>
            <td align="center">
                <table style="margin-top: 3px;">
                    <tr>
                        <td>
                            Inicial</td>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="DiaPeriodoInicialDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>01</asp:ListItem>
                                            <asp:ListItem>02</asp:ListItem>
                                            <asp:ListItem>03</asp:ListItem>
                                            <asp:ListItem>04</asp:ListItem>
                                            <asp:ListItem>05</asp:ListItem>
                                            <asp:ListItem>06</asp:ListItem>
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
                                            <asp:ListItem>21</asp:ListItem>
                                            <asp:ListItem>22</asp:ListItem>
                                            <asp:ListItem>23</asp:ListItem>
                                            <asp:ListItem>24</asp:ListItem>
                                            <asp:ListItem>25</asp:ListItem>
                                            <asp:ListItem>26</asp:ListItem>
                                            <asp:ListItem>27</asp:ListItem>
                                            <asp:ListItem>28</asp:ListItem>
                                            <asp:ListItem>29</asp:ListItem>
                                            <asp:ListItem>30</asp:ListItem>
                                            <asp:ListItem>31</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="MesPeriodoInicialDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>Janeiro</asp:ListItem>
                                            <asp:ListItem Value="02">Fevereiro</asp:ListItem>
                                            <asp:ListItem Value="03">Março</asp:ListItem>
                                            <asp:ListItem Value="04">Abril</asp:ListItem>
                                            <asp:ListItem Value="05">Maio</asp:ListItem>
                                            <asp:ListItem Value="06">Junho</asp:ListItem>
                                            <asp:ListItem Value="07">Julho</asp:ListItem>
                                            <asp:ListItem Value="08">Agosto</asp:ListItem>
                                            <asp:ListItem Value="09">Setembro</asp:ListItem>
                                            <asp:ListItem Value="10">Outubro</asp:ListItem>
                                            <asp:ListItem Value="11">Novembro</asp:ListItem>
                                            <asp:ListItem Value="12">Dezembro</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="AnoPeriodoInicialDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>2010</asp:ListItem>
                                            <asp:ListItem>2011</asp:ListItem>
                                            <asp:ListItem>2012</asp:ListItem>
                                            <asp:ListItem>2013</asp:ListItem>
                                            <asp:ListItem>2014</asp:ListItem>
                                            <asp:ListItem>2015</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td rowspan="2">
                            <asp:ImageButton ID="PeriodoButtom" runat="server" Height="36px" ImageUrl="~/Images/png/Select_2_32x32x32.png" Width="36px" onclick="PeriodoButtom_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Final</td>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="DiaPeriodoFinalDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>01</asp:ListItem>
                                            <asp:ListItem>02</asp:ListItem>
                                            <asp:ListItem>03</asp:ListItem>
                                            <asp:ListItem>04</asp:ListItem>
                                            <asp:ListItem>05</asp:ListItem>
                                            <asp:ListItem>06</asp:ListItem>
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
                                            <asp:ListItem>21</asp:ListItem>
                                            <asp:ListItem>22</asp:ListItem>
                                            <asp:ListItem>23</asp:ListItem>
                                            <asp:ListItem>24</asp:ListItem>
                                            <asp:ListItem>25</asp:ListItem>
                                            <asp:ListItem>26</asp:ListItem>
                                            <asp:ListItem>27</asp:ListItem>
                                            <asp:ListItem>28</asp:ListItem>
                                            <asp:ListItem>29</asp:ListItem>
                                            <asp:ListItem>30</asp:ListItem>
                                            <asp:ListItem>31</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="MesPeriodoFinalDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>Janeiro</asp:ListItem>
                                            <asp:ListItem Value="02">Fevereiro</asp:ListItem>
                                            <asp:ListItem Value="03">Março</asp:ListItem>
                                            <asp:ListItem Value="04">Abril</asp:ListItem>
                                            <asp:ListItem Value="05">Maio</asp:ListItem>
                                            <asp:ListItem Value="06">Junho</asp:ListItem>
                                            <asp:ListItem Value="07">Julho</asp:ListItem>
                                            <asp:ListItem Value="08">Agosto</asp:ListItem>
                                            <asp:ListItem Value="09">Setembro</asp:ListItem>
                                            <asp:ListItem Value="10">Outubro</asp:ListItem>
                                            <asp:ListItem Value="11">Novembro</asp:ListItem>
                                            <asp:ListItem Value="12">Dezembro</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="AnoPeriodoFinalDropDown" runat="server" 
                                            ForeColor="#3366CC">
                                            <asp:ListItem>2010</asp:ListItem>
                                            <asp:ListItem>2011</asp:ListItem>
                                            <asp:ListItem>2012</asp:ListItem>
                                            <asp:ListItem>2013</asp:ListItem>
                                            <asp:ListItem>2014</asp:ListItem>
                                            <asp:ListItem>2015</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            <td align="center">
                <table width="100">
                    <tr>
                        <td class="style1">
                            <asp:TextBox ID="NumeroTextBox" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="#3366CC" Width="61px"></asp:TextBox>
                        </td>
                        <td class="style1">
                            <asp:ImageButton ID="NumeroButtom" runat="server" Height="36px" ImageUrl="~/Images/png/Select_2_32x32x32.png" Width="36px" onclick="NumeroButtom_Click" />
                        </td>
                    </tr>
                </table>
            </td>
            <td align="center">
                <table width="100">
                    <tr>
                        <td>
                            <asp:TextBox ID="NomeTextBox" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="#3366CC" Width="85px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:ImageButton ID="NomeButtom" runat="server" Height="36px" ImageUrl="~/Images/png/Select_2_32x32x32.png" Width="36px" onclick="NomeButtom_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center" valign="top">
                Busca Todos de
                Hoje</td>
            <td align="center" valign="top">
                Busca Todos da
                Semana</td>
            <td align="center" valign="top">
                Busca Todos do
                Mês</td>
            <td align="center" valign="top">
                Busca por Período</td>
            <td align="center" valign="top">
                Busca por
                Número do Recado</td>
            <td align="center" valign="top">
                Busca por
                Nome do Cliente</td>
        </tr>
        <tr>
            <td align="center" colspan="6">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="center" colspan="6">
                <asp:Label ID="TituloLabel" runat="server" Font-Bold="True" Font-Size="Medium" 
                    Text="Recados"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="RecadosGridView" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Width="100%">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="Número" 
                DataNavigateUrlFormatString="Recado.aspx?{0}" DataTextField="Número" 
                HeaderText="Número" Target="_blank">
            <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="Data do Cadastro" DataFormatString="{0:d}" HeaderText="Data do Cadastro">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Nome Fantasia" HeaderText="Nome Fantasia">
            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Cidade" HeaderText="Cidade">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="True" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="DDD do Telefone do Contato" HeaderText="DDD">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Telefone do Contato" HeaderText="Telefone">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Ramal do Telefone do Contato" HeaderText="Ramal">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Wrap="False" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Nome do Contato" HeaderText="Nome do Contato">
            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Wrap="True" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="Observações" HeaderText="Observação" >
            <ItemStyle Font-Size="Small" HorizontalAlign="Left" VerticalAlign="Top" />
            </asp:BoundField>
            <asp:HyperLinkField DataNavigateUrlFields="Número" 
                DataNavigateUrlFormatString="Agenda.aspx?{0}" HeaderText="Agendar" 
                
                Text="&lt;img src=&quot;/Images/png/calendar-selection-day_1_256x256x32.png&quot; border=&quot;0&quot; width=&quot;32&quot; height=&quot;32&quot; /&gt;" 
                Target="_blank">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
            </asp:HyperLinkField>
            <asp:HyperLinkField DataNavigateUrlFields="Número" 
                DataNavigateUrlFormatString="RecadoDeclinar.aspx?{0}" HeaderText="Declinar" 
                
                Text="&lt;img src=&quot;/Images/png/Stop_2_32x32x32.png&quot; border=&quot;0&quot; width=&quot;32&quot; height=&quot;32&quot; /&gt;" 
                Target="_blank" Visible="False">
            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
            </asp:HyperLinkField>
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
</asp:Content>
