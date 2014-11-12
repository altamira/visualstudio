

--pr_pedidos_geracao_cnc
-------------------------------------------------------------------------------------------
-- Polimold
-- Stored Procedure : SQL Server
-- Autor(es)        : Cleiton Marques
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta de Pedidos para a geração de Programas CNC
-- Data             : 20/12/2002	
-- Atualizado       : 
CREATE PROCEDURE pr_pedidos_geracao_cnc
@dt_inicial datetime,          
@dt_final datetime

as

select e.sg_grupo_produto as 'Grupo',
       d.nm_fantasia_cliente as 'Cliente',
       a.dt_item_pedido_venda as 'Emissão',
       a.cd_pedido_venda as 'Pedido',
       a.cd_item_pedido_venda as 'Item',
       a.qt_item_pedido_venda as 'Qtd',
       c.nm_fantasia_produto as 'Produto',
       c.nm_produto as 'Descrição',
       a.dt_entrega_vendas_pedido as 'Entrega'
       
from Pedido_venda_item a,
     Pedido_Venda b,
     Produto c,
     Cliente d,
     Grupo_produto e
where a.dt_item_pedido_venda between @dt_inicial and @dt_final  and
      b.cd_pedido_venda=a.cd_pedido_venda and
      c.cd_produto=a.cd_produto and
      d.cd_cliente=b.cd_cliente and
      e.cd_grupo_produto=c.cd_grupo_produto and
      a.dt_cancelamento_item is not null and
      e.ic_cnc_grupo_produto='S' --and
     -- a.ic_gprgcnc_pedido_venda <>'S'
      
order by a.dt_item_pedido_venda

--select top 10 * from grupo_produto
--select top 10 * from Pedido_venda_item order by cd_pedido_venda desc
--select top 10 * from Pedido_venda order by cd_pedido_venda desc
--sp_help pedido_venda_item

