CREATE PROCEDURE pr_consulta_processo_pedido_venda

--pr_consulta_processo_pedido_venda
----------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Daniel Carrasco Neto
--Banco de Dados : EgisSQL
--Objetivo       : Consulta de Processos por Pedido de Venda.
--Data           : 23/08/2002
--Atualizado     :
--Alteração	 : 14/04/2003
--Desc. Alteração: Adiconado o atributo SG_TIPO_PEDIDO. - Carla
-------------------21/10/2003 -- Danilo
--Inclusão dos Campos N°Proposta, Item, Orçamento e Processista
--cd_consulta, cd_item_consulta, nm_vendedor e nm_processista respectivamente 
----------------------------------------------------------------
@cd_pedido_venda    int,
@dt_inicial    datetime,
@dt_final      datetime
AS
SELECT     pp.cd_processo, 
           pp.dt_processo, 
           pp.nm_processista,  
           pp.cd_pedido_venda, 
           pp.cd_item_pedido_venda, 
           c.nm_fantasia_cliente, 
           pvi.vl_unitario_item_pedido, 
           pvi.dt_entrega_vendas_pedido, 
           pvi.qt_item_pedido_venda,
           pvi.nm_fantasia_produto,
	   tp.sg_tipo_pedido,
           ci.cd_consulta, 
           ci.cd_item_consulta, 
           vnd.nm_vendedor 
FROM         Processo_Producao pp INNER JOIN
             (Pedido_Venda pv left outer join 
              ((Consulta cns inner join 
               vendedor vnd
              on cns.cd_vendedor_interno = vnd.cd_vendedor)
              inner join consulta_itens ci
              on ci.cd_consulta = cns.cd_consulta)
              on pv.cd_consulta = cns.cd_consulta)
             ON pp.cd_pedido_venda = pv.cd_pedido_venda 
             INNER JOIN
             Tipo_Pedido tp ON pv.cd_tipo_pedido = tp.cd_tipo_pedido LEFT OUTER JOIN   
             Pedido_Venda_Item pvi ON pv.cd_pedido_venda = pvi.cd_pedido_venda LEFT OUTER JOIN  
             Cliente c ON pv.cd_cliente = c.cd_cliente
where       (@cd_pedido_venda <> 0 and pp.cd_pedido_venda = @cd_pedido_venda) 
   OR       (@cd_pedido_venda = 0 and pp.dt_processo between @dt_inicial and @dt_final )
  and        pv.dt_cancelamento_pedido is null and pvi.dt_cancelamento_item is null
order by  pp.dt_processo desc,
          pp.cd_pedido_venda  
