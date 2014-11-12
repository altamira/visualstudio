
CREATE PROCEDURE pr_consulta_pedido_venda_sem_vendedor
@dt_inicial    datetime,
@dt_final       datetime,
@cd_pedido_venda int


AS

----------------------
if @cd_pedido_venda = 0
----------------------
begin
  SELECT     
    pv.cd_pedido_venda, 
    pv.dt_pedido_venda, 
    isnull(pv.vl_total_pedido_venda,0) as 'vl_total_pedido_venda', 
    vw.nm_fantasia as 'nm_fantasia_cliente',
    tp.nm_tipo_pedido
  FROM Pedido_Venda pv
  left outer join vw_Destinatario vw on
    vw.cd_destinatario=pv.cd_cliente and vw.cd_tipo_destinatario=1
  left outer join Tipo_Pedido tp on
    tp.cd_tipo_pedido=pv.cd_tipo_pedido
  WHERE      
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    pv.dt_cancelamento_pedido is null and
    IsNull(pv.cd_vendedor,0) = 0
end

----------------------
else
----------------------
  begin
  SELECT     
    pv.cd_pedido_venda, 
    pv.dt_pedido_venda, 
    isnull(pv.vl_total_pedido_venda,0) as 'vl_total_pedido_venda', 
    vw.nm_fantasia as 'nm_fantasia_cliente',
    tp.nm_tipo_pedido
  FROM Pedido_Venda pv
  left outer join vw_Destinatario vw on
    vw.cd_destinatario=pv.cd_cliente and vw.cd_tipo_destinatario=1
  left outer join Tipo_Pedido tp on
    tp.cd_tipo_pedido=pv.cd_tipo_pedido  WHERE 
    pv.cd_pedido_venda= @cd_pedido_venda and
    pv.dt_cancelamento_pedido is null and
    IsNull(pv.cd_vendedor,0) = 0
end

