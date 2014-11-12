
CREATE PROCEDURE pr_consulta_pedido_importacao_faturado
-------------------------------------------------------------------
--pr_consulta_pedido_importacao_faturado
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)		     : Paulo Souza
--Banco de Dados	 : EGISSQL
--Objetivo		     : Consulta de pedido de importacao faturado com
--                   importacao em aberto
--Data             : 14/03/2005
-------------------------------------------------------------------
@dt_inicio DateTime,
@dt_final DateTime

As
Begin
  Select
       Case
         When IsNull(pvi.dt_cancelamento_item,'') <> ''
           Then 'S'
         Else 'N'
       End as 'Cancelado',
       Case
         When IsNull(ns.cd_nota_saida,'') <> ''
           Then 'S'
         Else 'N'
       End as 'Faturado',
       c.nm_fantasia_cliente,
       pv.cd_pedido_venda,
       pvi.cd_item_pedido_venda,
       p.nm_fantasia_produto,
       pvi.qt_saldo_pedido_venda,
       ns.dt_nota_saida,
       ns.cd_nota_saida,
       nsi.cd_item_nota_saida,
       pi.cd_pedido_importacao,
       pi.cd_identificacao_pedido,
       pii.cd_item_ped_imp,
       pii.qt_saldo_item_ped_imp,
       pi.dt_pedido_importacao,
       f.nm_fantasia_fornecedor,
       sp.sg_status_pedido        
  From Pedido_Importacao_Item pii
       Inner Join Pedido_Importacao pi on pii.cd_pedido_importacao = pi.cd_pedido_importacao
       Inner Join Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pii.cd_pedido_venda and
                                           pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda     
       Inner Join Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
       Left Outer Join Cliente c on c.cd_cliente = pv.cd_cliente
       Left Outer Join Produto p on p.cd_produto = pii.cd_produto
       Left Outer Join Nota_Saida_Item nsi on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                              nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
       Left Outer Join Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
       Left Outer Join Fornecedor f on f.cd_fornecedor = pi.cd_fornecedor
       Left Outer Join Status_Pedido sp on sp.cd_status_pedido = pi.cd_status_pedido
  Where (pi.dt_pedido_importacao between @dt_inicio and @dt_final) and
        (pii.qt_saldo_item_ped_imp > 0) and
        (pvi.qt_saldo_pedido_venda = 0)
  Order by pi.dt_pedido_importacao desc
End

-- Exec pr_consulta_pedido_importacao_faturado '01/01/2005', '03/30/2005'


