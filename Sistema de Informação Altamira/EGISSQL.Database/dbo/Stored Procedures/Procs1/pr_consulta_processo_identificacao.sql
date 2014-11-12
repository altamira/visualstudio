

/****** Object:  Stored Procedure dbo.pr_consulta_processo_identificacao    Script Date: 13/12/2002 15:08:23 ******/

CREATE PROCEDURE pr_consulta_processo_identificacao

@cd_identificacao varchar(20),
@dt_inicial datetime,
@dt_final datetime

AS

SELECT     pp.cd_identifica_processo, 
           pp.cd_processo, 
           pp.dt_processo, 
           pp.cd_pedido_venda, 
           pp.cd_item_pedido_venda,
           pvi.qt_item_pedido_venda, 
           c.nm_fantasia_cliente, 
           pvi.nm_fantasia_produto

FROM       Processo_Producao pp LEFT outer join
           Pedido_Venda pv ON pp.cd_pedido_venda = pv.cd_pedido_venda INNER JOIN
           Pedido_Venda_Item pvi ON pvi.cd_pedido_venda = pp.cd_pedido_venda and
 				    pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda left outer join
           Cliente c ON pv.cd_cliente = c.cd_cliente

where     (pp.cd_identifica_processo like @cd_identificacao + '%') OR
          (@cd_identificacao = '' and pp.dt_processo between @dt_inicial and
                                                             @dt_final )

order by  pp.dt_processo desc

     


