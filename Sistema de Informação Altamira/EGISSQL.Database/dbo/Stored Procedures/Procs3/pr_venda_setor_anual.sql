-----------------------------------------------------------------------------------
--pr_venda_setor_anual
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Vendas por Setor anual
--Data        : 11.01.2000
--Atualizado  : 02.09.2000 
--            : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--            : 06/04/2002 - Alteração para o padrão do EGIS -Sandro Campos 
--            : 04/09/2002 - Filtro por Ano - Daniel C. Neto.
--            : 05/11/2002 - Acerto na quantidade de Pedidos de Venda por Vendedor (DUELA)
--		06/11/2003 - Incluído filtro por Moeda - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 13.03.2006 : Criação de um nova coluna - Meta Anual - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_venda_setor_anual 
@cd_vendedor int,
@cd_ano      int,
@cd_moeda    int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Total de Vendas Anual

select 
  c.nm_fantasia_vendedor                                             as 'Vendedor',
  year(vw.dt_pedido_venda)                                           as 'Ano' , 
  sum(vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido/ @vl_moeda) as 'Vendas',
  avg(vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido/ @vl_moeda) as 'media', 
  count(distinct vw.cd_pedido_venda)                                 as 'pedidos',
  dbo.fn_meta_vendedor(vw.cd_vendedor,'','',0,@cd_ano)               as 'Meta'  
into #VendaAnualSetor
from
  vw_venda_bi vw
left outer join Vendedor c on
  c.cd_vendedor=vw.cd_vendedor
where
  ((year(vw.dt_pedido_venda) = @cd_ano) or (@cd_ano = 0))  and
  (vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido/ @vl_moeda) > 0 
group by vw.cd_vendedor, c.nm_fantasia_vendedor, year(vw.dt_pedido_venda)
order by Vendas desc, Ano

declare   @vl_total_vendas float
set       @vl_total_vendas = 0

select    @vl_total_vendas = @vl_total_vendas + vendas
From
 #VendaAnualSetor

select 
  vendedor, 
  ano,
  isnull(vendas,0)                          as 'vendas',
  isnull(((vendas/@vl_total_vendas)*100),0) as 'perc',
  isnull(pedidos,0)                         as 'pedidos',
  isnull(((/*media*/vendas)/12),0)          as 'media_Mensal',
  isnull(meta,0)                            as 'Meta',
  (isnull(meta,0) / isnull(vendas,0) * 100) as 'atingido'
from
 #VendaAnualSetor
Order by Vendas desc, Ano

