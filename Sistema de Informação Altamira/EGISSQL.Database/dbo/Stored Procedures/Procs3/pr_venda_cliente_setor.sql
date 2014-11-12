
-----------------------------------------------------------------------------------
--pr_venda_cliente_setor
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Vendas por Cliente e Setor
--Data       : 11.01.2000
--Atualizado : 10.06.2000 Lucio (Seleção por Período)
--           : 19.07.2000 - Verificação do Cálculo
--           : 15.01.2001 Acerto da Ordem da Pesquisa - Campo Posicao
--           : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--           : 09/08/2002 - Trocado Código do Cliente por Nome do Cliente. - Daniel C. Neto.
--           : 11/11/2002 - Acerto na qtd. de Pedidos de Venda (DUELA)
-- 06/11/2003 - Daniel C. Neto - Inclusão de Moeda.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 06.03.2006 - 06.03.2006 - Acerto na Consulta - Carlos Fernandes
-----------------------------------------------------------------------------------

CREATE procedure pr_venda_cliente_setor
@cd_vendedor int = 0,
@dt_inicial  datetime,
@dt_final    datetime,
@cd_moeda    int = 1
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

-- Geração da Tabela Auxiliar de Vendas por Cliente
select 
  v.nm_fantasia_vendedor        as 'Vendedor',
  c.nm_fantasia_cliente         as 'Cliente', 
--  sum(vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido/ @vl_moeda) as 'Compra',
 
  cast(sum( isnull(vw.qt_item_pedido_venda,0) * (vw.vl_unitario_item_pedido)/ @vl_moeda)as decimal(25,2)) as 'Compra',

  cast(sum(dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda*
                                       (vw.vl_unitario_item_pedido / @vl_moeda))
                                  , vw.pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',

  max(vw.dt_pedido_venda)               as 'UltimaCompra', 
  count(distinct vw.cd_pedido_venda)    as 'pedidos'

into #VendaClienteAuxSetor1
from
  vw_venda_bi vw
left outer join Cliente c on 
  c.cd_cliente = vw.cd_cliente
left outer join Vendedor v on 
  v.cd_vendedor = vw.cd_vendedor
where
  vw.cd_vendedor=@cd_vendedor                            and
  vw.dt_pedido_venda between @dt_inicial  and @dt_final 
group by 
  vw.cd_vendedor, 
  v.nm_fantasia_vendedor, 
  vw.cd_cliente,
  c.nm_fantasia_cliente
order by 2 desc


declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set     @vl_total_cliente = 0
select  @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteAuxSetor1
order by compra desc

select
  IDENTITY(int, 1,1) AS 'Posicao',
  a.Vendedor,
  a.Cliente, 
  a.Compra, 
  a.TotalLiquido,
  (a.compra/@vl_total_cliente)*100    as 'Perc',
  a.UltimaCompra,
  a.pedidos
Into #VendaClienteSetor
from 
  #VendaClienteAuxSetor1 a
Order by a.Compra desc

--Mostra tabela ao usuário
select * from #VendaClienteSetor
order by posicao
