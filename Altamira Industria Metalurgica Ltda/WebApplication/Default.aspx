<%@ Page Title="Gestão de Vendas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .style2
        {
        width: 369px;
        text-align: left;
        background-color: #FFFFFF;
    }
        .style3
    {
        width: 155px;
        text-align: center;
    }
    .style4
    {
        width: 118px;
    }
    .style5
    {
        text-align: center;
        color: #000099;
        background-color: #3366CC;
    }
    .style6
    {
        width: 369px;
        text-align: left;
        color: #003399;
    }
    .style7
    {
        width: 155px;
        text-align: center;
        background-color: #99CCFF;
    }
    .style8
    {
        width: 118px;
        text-align: center;
        background-color: #99CCFF;
    }
    .style9
    {
        width: 132px;
    }
    .style10
    {
        color: #FFFFFF;
        background-color: #0066CC;
    }
    .style11
    {
        width: 132px;
        text-align: center;
        background-color: #99CCFF;
    }
    .style12
    {
        width: 369px;
        text-align: left;
        color: #003399;
        background-color: #99CCFF;
    }
    .style13
    {
        font-weight: bold;
        color: #0033CC;
    }
    .style14
    {
        color: #0033CC;
    }
        .style19
        {
            width: 132px;
            background-color: #99CCFF;
        }
        .style20
        {
            width: 118px;
            background-color: #99CCFF;
        }
        .style21
        {
            font-weight: bold;
            color: #0033CC;
            background-color: #FFFFFF;
        }
        .style22
        {
            color: #003399;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
<br />
    <table align="center" width="80%">
        <tr>
            <td class="style5" valign="top" colspan="4">
                <strong><span class="style10">Indicadores</span></strong></td>
        </tr>
        <tr>
            <td class="style2" valign="top">
                &nbsp;</td>
            <td class="style7">
                <strong>Nesta Semana</strong></td>
            <td class="style8">
                <strong>No Último Mês</strong></td>
            <td class="style11">
                <strong>No Último Ano</strong></td>
        </tr>
        <tr>
            <td class="style12">
                <strong>Número de Recados</strong></td>
            <td align="center" class="style7">
                <asp:Label ID="RecadosQuantidadeSemana" runat="server" CssClass="style14" 
                    style="text-align: center; font-weight: 700"></asp:Label>
            </td>
            <td align="center" class="style20">
                <asp:Label ID="RecadosQuantidadeMes" runat="server" CssClass="style14" 
                    style="text-align: center; font-weight: 700"></asp:Label>
            </td>
            <td align="center" class="style19">
                <asp:Label ID="RecadosQuantidadeAno" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <strong><span><span class="style22">Número de Orçamentos no Período</span>
                </span> </strong></td>
            <td align="center">
                <asp:Label ID="OrcamentosQuantidadeSemana" runat="server" CssClass="style21" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center">
                <asp:Label ID="OrcamentosQuantidadeMes" runat="server" CssClass="style21" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center">
                <asp:Label ID="OrcamentosQuantidadeAno" runat="server" CssClass="style21" 
                    style="text-align: center"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="style12">
                <strong>Número de Pedidos Fechados no Período </strong></td>
            <td align="center" class="style7">
                <asp:Label ID="PedidoQuantidadeSemana" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style8">
                <asp:Label ID="PedidoQuantidadeMes" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style11">
                <asp:Label ID="PedidoQuantidadeAno" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="style6">
                <strong>Valor dos Orçamentos no Período </strong></td>
            <td align="center" class="style3">
                <asp:Label ID="OrcamentosValorSemana" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style4">
                <asp:Label ID="OrcamentosValorMes" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style9">
                <asp:Label ID="OrcamentosValorAno" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="style12">
                <strong>Valor dos Pedidos Fechados no Período </strong></td>
            <td align="center" class="style7">
                <asp:Label ID="PedidoValorSemana" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style20">
                <asp:Label ID="PedidoValorMes" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
            <td align="center" class="style19">
                <asp:Label ID="PedidoValorAno" runat="server" CssClass="style13" 
                    style="text-align: center"></asp:Label>
            </td>
        </tr>
    </table>
<br />
</asp:Content>
