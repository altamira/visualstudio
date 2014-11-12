
CREATE PROCEDURE pr_consulta_pedido_venda_amostra
@cd_pedido_venda INT,
@dt_inicial DATETIME,
@dt_final DATETIME

As

IF @cd_pedido_venda = 0
  BEGIN
  	SELECT
			cli.nm_fantasia_cliente, --Cliente
			pv.cd_pedido_venda, --Pedido
			pv.dt_pedido_venda, --Emissão
			pvi.cd_item_pedido_venda,--Item
			pvi.qt_item_pedido_venda,--Quantidade Item
			pvi.qt_saldo_pedido_venda,--Saldo
			p.nm_fantasia_produto,--Produto
			p.nm_produto, --Descrição
			ve.nm_fantasia_vendedor as 'VendedorExterno',
			vi.nm_fantasia_vendedor as 'VendedorInterno'

		FROM
			Pedido_Venda pv
			LEFT OUTER JOIN
			Cliente cli
			ON
			pv.cd_cliente = cli.cd_cliente
			LEFT OUTER JOIN
			Pedido_Venda_Item pvi
			ON
			pv.cd_pedido_venda = pvi.cd_pedido_venda
			LEFT OUTER JOIN
			Produto p
			ON
			pvi.cd_produto = p.cd_produto
			LEFT OUTER JOIN
			Vendedor ve
			ON
			pv.cd_vendedor_pedido = ve.cd_vendedor
			LEFT OUTER JOIN
			Vendedor vi
			ON
			pv.cd_vendedor_interno = vi.cd_vendedor

		WHERE
			pv.dt_pedido_venda between @dt_inicial AND @dt_final AND	
			pv.ic_amostra_pedido_venda = 'S' 										 AND
			pv.dt_cancelamento_pedido is NULL
	 END
ELSE
	BEGIN
  	SELECT
			cli.nm_fantasia_cliente, --Cliente
			pv.cd_pedido_venda, --Pedido
			pv.dt_pedido_venda, --Emissão
			pvi.cd_item_pedido_venda,--Item
			pvi.qt_item_pedido_venda,--Quantidade Item
			pvi.qt_saldo_pedido_venda,--Saldo
			p.nm_fantasia_produto,--Produto
			p.nm_produto, --Descrição
			ve.nm_fantasia_vendedor as 'VendedorExterno',
			vi.nm_fantasia_vendedor as 'VendedorInterno'

		FROM
			Pedido_Venda pv
			LEFT OUTER JOIN
			Cliente cli
			ON
			pv.cd_cliente = cli.cd_cliente
			LEFT OUTER JOIN
			Pedido_Venda_Item pvi
			ON
			pv.cd_pedido_venda = pvi.cd_pedido_venda
			LEFT OUTER JOIN
			Produto p
			ON
			pvi.cd_produto = p.cd_produto
			LEFT OUTER JOIN
			Vendedor ve
			ON
			pv.cd_vendedor_pedido = ve.cd_vendedor
			LEFT OUTER JOIN
			Vendedor vi
			ON
			pv.cd_vendedor_interno = vi.cd_vendedor

		WHERE
			pv.cd_pedido_venda = @cd_pedido_venda AND	
			pv.ic_amostra_pedido_venda = 'S' 			AND
			pv.dt_cancelamento_pedido is NULL
	END

