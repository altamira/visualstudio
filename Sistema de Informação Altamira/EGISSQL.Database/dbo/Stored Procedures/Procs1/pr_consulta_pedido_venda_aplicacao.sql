
-------------------------------------------------------------------------------
--pr_consulta_pedido_venda_aplicacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta de pedido de venda por aplicação
--Data             : 28/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_pedido_venda_aplicacao
@cd_aplicacao int,
@dt_inicial datetime,
@dt_final datetime

as

	select	
		pv.cd_pedido_venda as 'código do pedido',
		pv.dt_pedido_venda as 'data pv',
		pv.vl_total_pedido_venda as 'valor total',
		pv.dt_cancelamento_pedido as 'data canc',
		pv.cd_aplicacao_produto as 'cd aplicação',
		v.nm_vendedor as 'vendedor externo',
		vi.nm_vendedor as 'vendedor interno',	
		pvi.cd_item_pedido_venda as 'item',
		pvi.qt_item_pedido_venda as 'qt item',
		pvi.qt_saldo_pedido_venda as 'qt saldo',
		pvi.vl_unitario_item_pedido as 'vl item',
		pvi.pc_ipi_item as 'ipi',
		pvi.pc_desconto_item_pedido as 'desconto',
		pvi.qt_liquido_item_pedido as 'liquido',
		pvi.qt_bruto_item_pedido as 'bruto',
		pvi.dt_ativacao_item as 'data ativ',
		pvi.nm_mot_ativ_item_pedido as 'motivo ativ',
		pvi.dt_necessidade_cliente as 'data nesc',
		pvi.qt_dia_entrega_cliente as 'qt dias',
		c.nm_fantasia_cliente as 'cliente',
		p.cd_mascara_produto as 'cd produto',
		p.nm_fantasia_produto as 'produto',
		ap.nm_aplicacao_produto as 'aplicação'
		
	
	from pedido_venda pv left outer join
		vendedor v on v.cd_vendedor = pv.cd_vendedor left outer join
		vendedor vi on vi.cd_vendedor = pv.cd_vendedor_interno left outer join
		pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda left outer join
		cliente c on c.cd_cliente = pv.cd_cliente left outer join
		aplicacao_produto ap on ap.cd_aplicacao_produto = pv.cd_aplicacao_produto left outer join
		produto p on p.cd_produto = pvi.cd_produto 

	where
     		pv.dt_pedido_venda  between @dt_inicial and @dt_final and
    		isnull(pv.dt_cancelamento_pedido,0)=0 and

		IsNull(pv.cd_aplicacao_produto,0) = 
			( case when @cd_aplicacao = 0 
			then
                           IsNull(pv.cd_aplicacao_produto,0) 
			else
                           @cd_aplicacao end)	
	order by
    		ap.nm_aplicacao_produto,
		pv.dt_pedido_venda desc
		

