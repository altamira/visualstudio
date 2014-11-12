CREATE PROCEDURE pr_consulta_pedido_programado_faturamento
	@ic_parametro int = 1,
	@cd_cliente int = 0,
	@nm_fantasia_produto varchar(30) = '',
	@cd_pedido_venda int = 0,
	@dt_inicio datetime,
	@dt_final datetime 
AS
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar
--Banco de Dados: Egissql
--Objetivo: Retorna uma consulta de todos os itens programados para faturamento
--Data: 21.01.2003

	--Define a fase do produto
	declare @cd_fase_produto int

	--Define a fase de revenda utilizada pela empresa	
	select top 1 @cd_fase_produto = cd_fase_produto from parametro_comercial
	where cd_empresa = dbo.fn_Empresa()

------------------------------------------------------------------------------------------
if @ic_parametro = 1    --Consulta sem faixa de período
------------------------------------------------------------------------------------------
  begin
	select 
		pvi.dt_progfat_item_pedido, --data da programação 	
		pv.cd_cliente, 		    --Código do Cliente do pedido
		(Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = pv.cd_cliente) as nm_fantasia_cliente, --Fantasia do cliente
		pv.dt_pedido_venda,         --data da emissão do pedido de venda
		pv.cd_pedido_venda,         --Código do pedido de venda
		pvi.cd_item_pedido_venda,   --Código do item do pedido de venda que foi programado
		pvi.qt_saldo_pedido_venda,  --Saldo a faturar do item programado
		pvi.qt_progfat_item_pedido, --Quantidade programada
		pvi.vl_unitario_item_pedido,--Valor Unitário do item
		(pvi.qt_progfat_item_pedido * pvi.vl_unitario_item_pedido) as vl_total_item_programado, --Valor Total Programado
		(
		Select 
			top 1 qt_saldo_atual_produto 
		from 
			Produto_saldo
		where 
			cd_produto = pvi.cd_produto 
			and cd_fase_produto = @cd_fase_produto
		) as qt_saldo_atual_produto,--Quantidade em estoque do produto
		pvi.cd_produto,             --Código do produto programado
		pvi.nm_fantasia_produto,    --Fantasia do produto programado
		pvi.dt_entrega_vendas_pedido,
		(Select 
			top 1 nm_tipo_entrega_produto 
		from 
			Tipo_entrega_produto 
		where 
			cd_tipo_entrega_produto = pv.cd_tipo_entrega_produto) as nm_tipo_entrega_produto --Forma de entrega
	
	From 
		Pedido_venda_item pvi 
		left outer join Pedido_venda pv
		on (pv.cd_pedido_venda=pvi.cd_pedido_venda) 
	where 
		--Filtro dos itens programados
		((pvi.ic_progfat_item_pedido='S' or pvi.ic_progfat_item_pedido='A') and 
		pvi.qt_progfat_item_pedido > 0 and 
		pvi.qt_saldo_pedido_venda > 0 and 
		pv.cd_status_pedido = 1 )	
		--Parametro para filtrage adicional
		--Por Cliente
		and ((IsNull(@cd_cliente,0) = 0) or 
		(IsNull(@cd_cliente,0) <> 0 and pv.cd_cliente = @cd_cliente))
		--Por Produto
		and ((IsNull(@nm_fantasia_produto,'') = '') or 
		(IsNull(@nm_fantasia_produto,'') <> '' and pvi.nm_fantasia_produto like @nm_fantasia_produto + '%'))
		--Por Pedido
		and ((IsNull(@cd_pedido_venda,0) = 0) or 
		(IsNull(@cd_pedido_venda,0) <> 0 and pvi.cd_pedido_venda = @cd_pedido_venda))	
	order by 
		ic_progfat_item_pedido, pvi.cd_pedido_venda,
		pvi.cd_item_pedido_venda
end
------------------------------------------------------------------------------------------
if @ic_parametro = 2    --Consulta com faixa de período
------------------------------------------------------------------------------------------
  begin
	select 
		pvi.dt_progfat_item_pedido, --data da programação 	
		pv.cd_cliente, 		    --Código do Cliente do pedido
		(Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = pv.cd_cliente) as nm_fantasia_cliente, --Fantasia do cliente
		pv.dt_pedido_venda,         --data da emissão do pedido de venda
		pv.cd_pedido_venda,         --Código do pedido de venda
		pvi.cd_item_pedido_venda,   --Código do item do pedido de venda que foi programado
		pvi.qt_saldo_pedido_venda,  --Saldo a faturar do item programado
		pvi.qt_progfat_item_pedido, --Quantidade programada
		pvi.vl_unitario_item_pedido,--Valor Unitário do item
		(pvi.qt_progfat_item_pedido * pvi.vl_unitario_item_pedido) as vl_total_item_programado, --Valor Total Programado
		(
		Select 
			top 1 qt_saldo_atual_produto 
		from 
			Produto_saldo
		where 
			cd_produto = pvi.cd_produto 
			and cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_produto)
		) as qt_saldo_atual_produto,--Quantidade em estoque do produto
		pvi.cd_produto,             --Código do produto programado
		pvi.nm_fantasia_produto,    --Fantasia do produto programado
		pvi.dt_entrega_vendas_pedido,
		(Select 
			top 1 nm_tipo_entrega_produto 
		from 
			Tipo_entrega_produto 
		where 
			cd_tipo_entrega_produto = pv.cd_tipo_entrega_produto) as nm_tipo_entrega_produto --Forma de entrega
	
	From 
		Pedido_venda_item pvi 
		left outer join Pedido_venda pv on (pv.cd_pedido_venda=pvi.cd_pedido_venda) 
      left outer join Produto p on p.cd_produto = pvi.cd_produto
	where 
		--Filtro dos itens programados
		((pvi.ic_progfat_item_pedido='S' or pvi.ic_progfat_item_pedido='A') and 
		pvi.qt_progfat_item_pedido > 0 and 
		pvi.qt_saldo_pedido_venda > 0 and 
		pv.cd_status_pedido = 1 
		and (pvi.dt_progfat_item_pedido between @dt_inicio and @dt_final))	
		--Parametro para filtrage adicional
		--Por Cliente
		and ((IsNull(@cd_cliente,0) = 0) or 
		(IsNull(@cd_cliente,0) <> 0 and pv.cd_cliente = @cd_cliente))
		--Por Produto
		and ((IsNull(@nm_fantasia_produto,'') = '') or 
		(IsNull(@nm_fantasia_produto,'') <> '' and pvi.nm_fantasia_produto like @nm_fantasia_produto + '%'))
		--Por Pedido
		and ((IsNull(@cd_pedido_venda,0) = 0) or 
		(IsNull(@cd_pedido_venda,0) <> 0 and pvi.cd_pedido_venda = @cd_pedido_venda))	
	order by 
		ic_progfat_item_pedido, pvi.cd_pedido_venda,
		pvi.cd_item_pedido_venda
end

