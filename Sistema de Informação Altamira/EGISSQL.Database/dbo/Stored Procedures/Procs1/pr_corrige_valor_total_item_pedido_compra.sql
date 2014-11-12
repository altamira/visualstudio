
-------------------------------------------------------------------------------
--pr_corrige_valor_total_item_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Corrigir o valor total do item do Pedido de Compra
--                 : Quando o Item tiver IPI
--Data             : 05/02/2005
--Atualizado       : 05/02/2005
--------------------------------------------------------------------------------------------------
create procedure pr_corrige_valor_total_item_pedido_compra
@dt_inicial datetime,
@dt_final   datetime

as

--select cd_cotacao,pc_ipi,vl_total_item_pedido_comp,* from pedido_compra_item where cd_pedido_compra > 201438

update
  Pedido_Compra_Item

set
  vl_total_item_pedido_comp =

    case when IsNull(pc_ipi,0) > 0 then
      (qt_item_pedido_compra * vl_item_unitario_ped_comp ) + 
     ((qt_item_pedido_compra * vl_item_unitario_ped_comp ) * (pc_ipi / 100) )
    else
      (qt_item_pedido_compra * vl_item_unitario_ped_comp ) end

where
  dt_item_pedido_compra between @dt_inicial and @dt_final

