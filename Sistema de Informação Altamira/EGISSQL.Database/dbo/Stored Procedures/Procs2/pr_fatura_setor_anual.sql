--pr_fatura_setor_anual
------------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2006
------------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Faturass por Setor anual
--Data       : 14.08.2000
--Atualizado : 15/08/2002 - Migração bco. Egis - DUELA
--           : 04/09/2002 - Filtro por Ano - Daniel C. Neto.
--           : 06/11/2002 - Acerto na quantidade de Notas de Saída por Vendedor (DUELA)
--                        - Acerto de Joins e Filtros que indicam q é nota de saída
-- 06/11/2003 - Daniel C. Neto - Incluído filtro por moeda.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 14.03.2006 - Meta do Vendedor - Carlos Fernandes
-----------------------------------------------------------------------------------
CREATE procedure pr_fatura_setor_anual 
@cd_vendedor int,
@cd_ano      int,
@cd_moeda int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Total de Faturas Anual
select 
  f.nm_fantasia_vendedor    as 'Vendedor',
  year(a.dt_nota_saida)     as 'Ano' , 
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) as 'Vendas',

  /*(select distinct
     count(ns.cd_nota_saida)
   from
     Nota_Saida ns 
   left outer join Operacao_Fiscal opf on 
     opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
   where
     ((year(ns.dt_nota_saida) = @cd_ano) or
      (year(ns.dt_nota_saida) > 1994) and (@cd_ano = 0)) and
     opf.ic_comercial_operacao = 'S'                       and
     opf.cd_tipo_movimento_estoque=11                      and
     ns.vl_total > 0                                       and
     isnull(ns.cd_status_nota,5)<> 7                       and     
     ns.dt_cancel_nota_saida is null                       and
     ns.cd_vendedor = a.cd_vendedor) as 'Pedidos',*/
  count(distinct a.cd_nota_saida)                  as 'pedidos',
  avg(a.vl_total/ @vl_moeda)                       as 'media',
  dbo.fn_meta_vendedor(1,'','',0,@cd_ano)          as 'Meta'

into #FaturaSetorAnual
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida
left outer join Pedido_Venda_Item c on
  (c.cd_item_pedido_venda = b.cd_item_pedido_venda and
   c.cd_pedido_venda = b.cd_pedido_venda)
left outer join Pedido_Venda d on
   d.cd_pedido_venda = b.cd_pedido_venda
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal=a.cd_operacao_fiscal
left outer join Vendedor f on
  f.cd_vendedor=a.cd_vendedor
where
   ((year(a.dt_nota_saida) = @cd_ano) or (@cd_ano = 0)) and
   a.dt_cancel_nota_saida is null                       and
   (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)       and
   e.ic_comercial_operacao = 'S'                        and
   e.cd_tipo_movimento_estoque=11                       and
   isnull(d.ic_consignacao_pedido,'N') = 'N'            and    
   c.ic_smo_item_pedido_venda='N'                       and     
   a.vl_total > 0                                       and       
   isnull(b.ic_status_item_nota_saida,'')<>'C'          and
   (b.dt_cancel_item_nota_saida is null or b.dt_cancel_item_nota_saida>getdate()) and
   (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>0  
group by a.cd_vendedor, f.nm_fantasia_vendedor, year(a.dt_nota_saida)
order by 1 desc


-- Devoluções do Mês Corrente
select 
  year(a.dt_nota_saida)                             as 'Ano' , 
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) as 'Vendas',
  sum((case when isnull (b.qt_devolucao_Item_nota,0)>0 then
  b.qt_devolucao_item_nota else b.qt_item_nota_saida end) * 
  b.vl_unitario_item_nota/ @vl_moeda) as 'Fat_Devolucao_Ant' 
into #FaturaSetorAnualDev
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida
left outer join Pedido_Venda_Item c on
  (c.cd_item_pedido_venda = b.cd_item_pedido_venda and
   c.cd_pedido_venda = b.cd_pedido_venda)
left outer join Pedido_Venda d on
   d.cd_pedido_venda = b.cd_pedido_venda
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal=a.cd_operacao_fiscal
where
   ((year(a.dt_nota_saida) = @cd_ano) or
    (year(a.dt_nota_saida) > 1994) and (@cd_ano = 0)) and
   (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)  and
   e.ic_comercial_operacao = 'S'                   and
   e.cd_tipo_movimento_estoque=11                  and
   year(b.dt_cancel_item_nota_saida) > 1994        and
   b.ic_status_item_nota_saida='D'                 and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>0 and
   c.cd_item_pedido_venda<80                       and
   c.ic_smo_item_pedido_venda='N'                          
group by year(a.dt_nota_saida)
order by Vendas desc, Ano


-- Devoluções dos Meses Anteriores
select 
  year(a.dt_nota_saida)                             as 'Ano' , 
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) as 'Vendas',
  sum((case when isnull (b.qt_devolucao_Item_nota,0)>0 then
  b.qt_devolucao_item_nota else b.qt_item_nota_saida end) * 
  b.vl_unitario_item_nota/ @vl_moeda) as 'Fat_Devolucao_Ant' 
into #FaturaSetorAnualAnt
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida
left outer join Pedido_Venda_Item c on
  (c.cd_item_pedido_venda = b.cd_item_pedido_venda and
   c.cd_pedido_venda = b.cd_pedido_venda)
left outer join Pedido_Venda d on
   d.cd_pedido_venda = b.cd_pedido_venda
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal=a.cd_operacao_fiscal
where
  ((year(a.dt_nota_saida) = @cd_ano) or
   (year(a.dt_nota_saida) > 1994) and (@cd_ano = 0)) and
  (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)   and
  e.ic_comercial_operacao = 'S'                    and
  e.cd_tipo_movimento_estoque=11                   and
  year(b.dt_cancel_item_nota_saida) > 1994         and
  b.ic_status_item_nota_saida='D'                  and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>0 and
  c.cd_item_pedido_venda<80                        and
  c.ic_smo_item_pedido_venda='N'                          
group by year(a.dt_nota_saida)
order by 1 desc


select 
  a.Vendedor,
  a.Ano,
  a.Pedidos,
  a.Media,
  vendas = (a.vendas-isnull(c.Fat_Devolucao_Ant,0)) + isnull(b.vendas,0),
  isnull(a.meta,0)                            as 'Meta',
  (isnull(a.meta,0) / isnull(vendas,0) * 100) as 'atingido'

into #FaturaSetorAnual1
from #FaturaSetorAnual a, #FaturaSetorAnualDev b, #FaturaSetorAnualAnt c
where 
  a.ano *= b.ano and
  a.ano *= c.ano

declare @vl_total_vendas float
set     @vl_total_vendas = 0

select  @vl_total_vendas = @vl_total_vendas + vendas
From
 #FaturaSetorAnual1

select 
  vendedor, 
  ano,
  isnull(vendas,0)                          as 'vendas',
  isnull(((vendas/@vl_total_vendas)*100),0) as 'perc',
  isnull(pedidos,0)                         as 'pedidos',
  isnull(((vendas)/12),0)                   as 'Media_mensal',
  meta,
  atingido
from
 #FaturaSetorAnual1
Order by Vendas desc, Ano


