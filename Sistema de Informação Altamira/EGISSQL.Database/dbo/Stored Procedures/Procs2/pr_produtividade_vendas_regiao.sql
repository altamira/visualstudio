
create procedure pr_produtividade_vendas_regiao
@dt_inicial datetime,
@dt_final   datetime
as

--Total Vendas por Região

declare @vl_total_venda  float
set @vl_total_venda = 0

select  
  @vl_total_venda = sum( qt_item_pedido_venda * vl_unitario_item_pedido )
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final

--select * from vw_venda_bi where  dt_pedido_venda between '01/01/2004' and '01/31/2004' order by cd_regiao_venda
--select * from regiao_venda
--select * from vendedor_regiao

select  
  max(rv.nm_regiao_venda)                                     as 'Regiao',
  
  sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido ) as 'TotalVenda',

  --(%) Sobre o Total de Vendas
( sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido ) /
  @vl_total_venda ) * 100                                     as 'Perc',                                                        
  
  --Quantidade de Vendedores da Região

  (select count(*) from Vendedor_Regiao where cd_regiao_venda = vw.cd_regiao_venda ) as 'QtdVendedor'

into #Venda_Regiao

from 
  vw_venda_bi     vw, 
  regiao_venda    rv
where 
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_regiao_venda = rv.cd_regiao_venda
group by
  vw.cd_regiao_venda
 
--Resultado

select 
  *,
  TotalVenda/QtdVendedor as TotalVendedor
from 
  #Venda_Regiao 

