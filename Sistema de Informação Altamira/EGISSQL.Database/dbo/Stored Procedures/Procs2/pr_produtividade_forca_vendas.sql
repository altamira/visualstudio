
create procedure pr_produtividade_forca_vendas
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_vendedor_ativo int
declare @qt_vendedor_venda int
declare @vl_total_venda    float

--Número de Vendedores Ativos

set @qt_vendedor_ativo = 0


select 
  @qt_vendedor_ativo = count(*) 
from 
  vendedor 
where
  isnull(ic_ativo,'N')='S'     

--Número de Vendedors que Efeturam Vendas
set @qt_vendedor_venda = 0


--Total de Vendas
set @vl_total_venda = 0


-- select * from vw_venda_bi where 
-- dt_pedido_venda between @dt_inicial and @dt_final


--Total de Vendedores que Efeturam as Vendas

select  
  @qt_vendedor_venda = count('x') 
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final
group by
  cd_vendedor

--Total de Vendas

select  
  @vl_total_venda = sum( qt_item_pedido_venda * vl_unitario_item_pedido )
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final


--Resultado

select 
  @qt_vendedor_ativo                 as 'Ativo',
  @qt_vendedor_venda                 as 'Vendedor',
  @vl_total_venda                    as 'Total',
  @vl_total_venda/@qt_vendedor_venda as 'ForcaVenda'

