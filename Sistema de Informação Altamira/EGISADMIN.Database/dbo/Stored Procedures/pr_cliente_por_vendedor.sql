/****** Object:  Stored Procedure dbo.pr_cliente_por_vendedor   ******/

--pr_venda_cliente_setor
-----------------------------------------------------------------------------------
--GBS-Global Business Solution                          2003                     
--Stored Procedure : SQL Server Microsoft 2000
--Antonio Palacio Junior
--Clientes atendidos por vendedor
--Data       : 23.04.2003
--Atualizado :

-----------------------------------------------------------------------------------

CREATE procedure pr_cliente_por_vendedor
@cd_vendedor int,
@dt_inicial  datetime,
@dt_final    datetime
as


-- Geração da Tabela Auxiliar de Vendas por Cliente
Select 
  Cli.cd_cliente,
  Cli.nm_fantasia_cliente as 'Cliente',
  (select top 1 
     cc.nm_contato_cliente 
   from 
     Cliente_Contato cc 
   where 
     cc.cd_cliente = Cli.cd_cliente) as 'nm_contato_cliente',
     cast(isnull((select 
     sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
   from
     Pedido_Venda pv inner join
     Pedido_Venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda
   where
     pv.cd_vendedor = @cd_vendedor and 
     pv.cd_cliente = Cli.cd_cliente and
     pv.dt_pedido_venda between @dt_inicial  and @dt_final and
     pv.dt_cancelamento_pedido is null),0) as decimal(15,2)) as 'Compra',
     max(a.dt_pedido_venda)      as 'UltimaCompra', 
  (select 
    count(pv.cd_pedido_venda)
   from
     Pedido_Venda pv
   where
     pv.cd_vendedor = @cd_vendedor                and
     pv.cd_cliente = Cli.cd_cliente                 and
     isnull(a.ic_consignacao_pedido,'N') = 'N' and
     a.dt_pedido_venda between @dt_inicial  and @dt_final ) as 'pedidos'
into #VendaClienteAuxSetor1
from        
  Cliente Cli LEFT OUTER JOIN
  Regiao_Venda RegVend ON Cli.cd_regiao = RegVend.cd_regiao_venda,
  pedido_venda a 
left outer join  pedido_venda_item b on 
  b.cd_pedido_venda = a.cd_pedido_venda
left outer join Cliente c on 
  c.cd_cliente = a.cd_cliente
left outer join Vendedor v on 
  v.cd_vendedor = a.cd_vendedor
where
  a.cd_vendedor = @cd_vendedor                            and
  a.dt_pedido_venda between @dt_inicial and @dt_final and
  isnull(a.ic_consignacao_pedido,'N') = 'N'        
group by 
  a.cd_vendedor, v.nm_fantasia_vendedor, a.cd_cliente, c.nm_fantasia_cliente,
	a.dt_pedido_venda, Cli.cd_cliente, a.ic_consignacao_pedido, Cli.nm_fantasia_cliente
order by 
  2 desc


declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set     @vl_total_cliente = 0

select  
  @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteAuxSetor1
order by 
  compra desc

select
  IDENTITY(int, 1,1) as 'Posicao',
  a.Cliente, 
  a.nm_contato_cliente,
  a.Compra, 
 (a.compra/@vl_total_cliente)*100    as 'Perc',
  a.UltimaCompra,
  a.pedidos
Into 
  #VendaClienteSetor
from 
  #VendaClienteAuxSetor1 a
Order by 
  a.Compra desc

--Mostra tabela ao usuário
select 
  * 
from 
  #VendaClienteSetor
order by 
  posicao

