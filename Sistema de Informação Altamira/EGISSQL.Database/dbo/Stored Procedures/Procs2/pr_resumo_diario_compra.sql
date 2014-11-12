
CREATE PROCEDURE pr_resumo_diario_compra
@dt_inicial   datetime,
@dt_final     datetime

as

  declare @vl_total_compra float
  declare @vl_geral float
  set @vl_total_compra = 0
  set @vl_geral = (select sum(pc.vl_total_pedido_compra)from  Pedido_Compra pc where
     pc.dt_pedido_compra  between @dt_inicial and @dt_final and
     pc.dt_cancel_ped_compra is null )
  --Calcula o Total de Compras

  select @vl_total_compra = @vl_total_compra + pc.vl_total_pedido_compra
  from
     Pedido_Compra pc
  where
     pc.dt_pedido_compra  between @dt_inicial and @dt_final and
     pc.dt_cancel_ped_compra is null 

  select 
     pc.dt_pedido_compra                                    as 'DataPedido',
     isnull(count(*),0)                                     as 'QtdPedido',
     isnull(sum(pc.vl_total_pedido_compra ),0)              as 'TotalCompra',
     isnull((sum(pc.vl_total_pedido_compra ) * 100) / @vl_geral,0)    as 'Perc'
     



  from
     Pedido_Compra pc
  where
     pc.dt_pedido_compra  between @dt_inicial and @dt_final and
     pc.dt_cancel_ped_compra is null 
  group by
    pc.dt_pedido_compra
  order by
    pc.dt_pedido_compra
 

--sp_help pedido_compra

