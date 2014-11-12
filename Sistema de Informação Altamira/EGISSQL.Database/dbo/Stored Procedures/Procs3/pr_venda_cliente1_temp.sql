create procedure pr_venda_cliente1_temp
@dt_inicial datetime,
@dt_final datetime,
@cd_moeda int
as

-- Geração da Tabela Auxiliar de Vendas por Cliente
select 
  c.nm_fantasia_cliente                                 as 'Cliente', 
  a.cd_cliente,
  cast(sum(b.qt_item_pedido_venda*(b.vl_unitario_item_pedido * dbo.fn_vl_moeda(@cd_moeda))) as decimal(25,2)) as 'Compra', 
  cast(sum(dbo.fn_vl_liquido_venda('V',(b.qt_item_pedido_venda*
                                       (b.vl_unitario_item_pedido * dbo.fn_vl_moeda(@cd_moeda)))
                                  , b.pc_icms_item)) as decimal(25,2)) as 'TotalLiquido',

  max(a.dt_pedido_venda)                                as 'UltimaCompra', 
  count(a.cd_pedido_venda)                              as 'pedidos',
  (select top 1 v.nm_fantasia_vendedor
   from vendedor v
   where v.cd_vendedor = a.cd_vendedor)                 as 'setor'
into #VendaClienteAux1
from 
  pedido_venda a
left outer join Pedido_Venda_Item b on
  b.cd_pedido_venda=a.cd_pedido_venda
left outer join Cliente c on
  c.cd_cliente=a.cd_cliente
where
 (a.dt_pedido_venda between @dt_inicial and @dt_final)  and
  isnull(a.ic_consignacao_pedido,'N') = 'N'             and
  b.qt_item_pedido_venda*b.vl_unitario_item_pedido > 0  and
  a.dt_cancelamento_pedido is null                      and
  b.dt_cancelamento_item is null                        
group by c.nm_fantasia_cliente, a.cd_cliente, a.cd_vendedor
order by Compra desc

declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set @vl_total_cliente = 0
select @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteAux1

--Define tabela com Total Geral de Venda Ano
--select @vl_total_cliente as 'TOTALANO' 
--into ##TotalVendaAno

--Cria a Tabela Final de Vendas por Cliente
-- Define a posição de Compra do Cliente - IDENTITY

select IDENTITY(int, 1,1) as 'Posicao',
       cd_cliente,
       Cliente, 
       Compra, 
       TotalLiquido,
       cast(((Compra / @vl_total_cliente ) * 100) as decimal (25,2)) as 'Perc',
       UltimaCompra,
       setor, 
       pedidos
Into #VendaCliente1
from #VendaClienteAux1
Order by Compra desc

--Mostra tabela ao usuário
select * from #VendaCliente1
order by posicao

