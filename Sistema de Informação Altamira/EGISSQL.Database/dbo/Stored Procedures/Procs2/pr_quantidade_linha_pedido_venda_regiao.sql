
create procedure pr_quantidade_linha_pedido_venda_regiao
@dt_inicial datetime,
@dt_final   datetime
as

select  

  max(rv.nm_regiao_venda)                                                            as 'Regiao',

  --Quantidade de Vendedores da Região

  (select count(*) from Vendedor_Regiao where cd_regiao_venda = vw.cd_regiao_venda ) as 'QtdVendedor',

  --Quantidade de Linhas Pedidos da Região
  count(vw.cd_item_pedido_venda)                                                     as 'QtdLinha'
 
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
  QtdLinha/QtdVendedor as 'LinhaVendedor'
from 
  #Venda_Regiao 


