
CREATE VIEW vw_mercador_pedido_registro_04
------------------------------------------------------------------------------------
--sp_helptext vw_mercador_pedido_registro_04
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Gera dados do item do Pedido de venda para 
--                        EDI-Mercador
--Data                  : 27.06.2008
--Atualização           : 
-- 
------------------------------------------------------------------------------------
as

--select * from pedido_venda
--select cd_mascara_produto,* from pedido_venda_item

select
  pv.cd_pedido_venda,
  pv.dt_pedido_venda       as DATA_EMISSAO,
  pvi.cd_item_pedido_venda as ITEM_PEDIDO,
  '1'                      as QUALIF_ALTERACAO,
  'EN'                     as TP_CODIGO_PRODUTO,
  p.cd_mascara_produto     as CODIGO_PRODUTO,
  pvi.nm_produto_pedido    as DESCRICAO_PRODUTO
from
  pedido_venda_item pvi           with (nolock)
  inner join      pedido_venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
  left outer join produto p       with (nolock) on p.cd_produto       = pvi.cd_produto
  
 


