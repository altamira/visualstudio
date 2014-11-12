
-------------------------------------------------------------------------------
--pr_pedido_venda_sem_numero_serie
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--                 : 16/07/2005 - Inclusão de flag para verificação do numero de serie do produto. - Diego Santiago
--------------------------------------------------------------------------------------------------
create procedure pr_pedido_venda_sem_numero_serie
@dt_inicial datetime,
@dt_final   datetime
as

--select * from pedido_venda_item

select
  c.nm_fantasia_cliente        as Cliente,
  pv.cd_pedido_venda           as Pedido,
  pv.dt_pedido_venda           as Emissao,
  pvi.cd_item_pedido_venda     as Item,
  pvi.qt_item_pedido_venda     as Qtd,
  p.cd_mascara_produto         as Codigo,
  p.nm_fantasia_produto        as Fantasia,
  pvi.nm_produto_pedido        as Descricao,
  um.sg_unidade_medida         as Unidade,
  pvi.dt_entrega_vendas_pedido as Entrega,
  pvi.vl_unitario_item_pedido  as Unitario,
  pvi.qt_item_pedido_venda * 
  pvi.vl_unitario_item_pedido  as Total,
  pvi.cd_num_serie_item_pedido as NumeroSerie

from
  Pedido_Venda pv 
  left outer join Cliente c             on c.cd_cliente         = pv.cd_cliente
  left outer join Pedido_Venda_Item pvi on pvi.cd_pedido_venda  = pv.cd_pedido_venda
  left outer join Produto p             on p.cd_produto         = pvi.cd_produto
  left outer join Unidade_Medida um     on um.cd_unidade_medida = p.cd_unidade_medida
where
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  pvi.dt_cancelamento_item is null and
  pvi.cd_num_serie_item_pedido is null and
  isnull(p.ic_numero_serie_produto,'N')='S'

order by
  pv.dt_pedido_venda desc
