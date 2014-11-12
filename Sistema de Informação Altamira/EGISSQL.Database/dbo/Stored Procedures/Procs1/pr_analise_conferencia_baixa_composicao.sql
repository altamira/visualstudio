
CREATE   PROCEDURE pr_analise_conferencia_baixa_composicao
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar 
--Banco de Dados: Egissql
--Objetivo      : Lista as produtos da composição das notas fiscais onde não foi encontrado um movimento de estoque
--                correspondente ao mesmo
--Data          : 15.06.2003
--Alteração     : 13.05.2004 - Mudança para Funcionar a verificação para os Kits e Produtos Especiais
-------------------------------------------------------------

		@cd_produto int = 0,
		@cd_pedido_venda int = 0,
		@cd_item_pedido_venda int = 0,
		@cd_nota_saida        varchar(30) = '0',
		@cd_item_nota_saida   int = 0
AS

-- ============================================================
-- Seleciona todos os pedidos de venda que tenham sido fechados
-- contudo não geraram estoque de reserva no estoque
-- ============================================================
--Mudança da verificação para funcionamento para os kit´s
if exists(Select 'x' from Pedido_Venda_Composicao 
          where cd_pedido_venda = @cd_pedido_venda and 
		      cd_item_pedido_venda = @cd_item_pedido_venda )
begin
	Select 
		pvc.cd_pedido_venda,
		pvc.cd_item_pedido_venda,
		pvc.cd_id_item_pedido_venda,
		(Select top 1 nm_fantasia_produto from Produto where cd_produto = pvc.cd_produto) as nm_fantasia_produto,
		pvc.qt_item_produto_comp as qtd_composicao,
		pvc.cd_fase_produto,
		(Select top 1 nm_fase_produto from Fase_Produto where cd_fase_produto = pvc.cd_fase_produto) as nm_fase_produto
	from 
		Pedido_Venda_Composicao pvc left outer join
		(Select * from Movimento_estoque where cd_documento_movimento = @cd_nota_saida and cd_item_documento = @cd_item_nota_saida) as me 
		on pvc.cd_produto = me.cd_produto
	where
		pvc.cd_pedido_venda = @cd_pedido_venda and
		pvc.cd_item_pedido_venda = @cd_item_pedido_venda and
		me.cd_produto is null
end
else
begin
	Select 
		@cd_pedido_venda      as cd_pedido_venda,
		@cd_item_pedido_venda as cd_item_pedido_venda,
		0                     as cd_id_item_pedido_venda,
		(Select top 1 nm_fantasia_produto from Produto where cd_produto = pc.cd_produto) as nm_fantasia_produto,
		cast(pc.qt_item_produto as float) as qtd_composicao,
		pc.cd_fase_produto,
		(Select top 1 nm_fase_produto from Fase_Produto where cd_fase_produto = pc.cd_fase_produto) as nm_fase_produto
	from 
		(Select * from Produto_Composicao where cd_produto_pai = @cd_produto) pc left outer join
		(Select * from Movimento_estoque where cd_documento_movimento = @cd_nota_saida and cd_item_documento = @cd_item_nota_saida) as me 
		on pc.cd_produto = me.cd_produto

	where
		me.cd_produto is null	
end
