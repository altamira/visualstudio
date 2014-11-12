

CREATE   PROCEDURE pr_analise_conferencia_baixa_movimento_errado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar 
--Banco de Dados: Egissql
--Objetivo      : Lista as notas fiscais onde não foi encontrado um movimento de estoque
--                correspondente ao mesmo
--Data          : 28.04.2003
--Atualizado    : 29/05/2003 
--                Acertos, inclusão de campos.
--Atualização   : Daniel C. Neto.
--              : 14/06/2003 - Revisão Geral - Carlos
-------------------------------------------------------------

		@cd_nota_saida int = 0,
		@dt_inicial datetime,
		@dt_final datetime

AS
Select 
	nsi.cd_produto,
	(Select top 1 nm_fantasia_produto from produto where cd_produto = nsi.cd_produto) as nm_fantasia_produto_sft,
	nsi.cd_nota_saida,
	nsi.cd_item_nota_saida,
	me.cd_produto,
	(Select top 1 nm_fantasia_produto from produto where cd_produto = me.cd_produto) as nm_fantasia_produto_sce
from 
	(Select * from Nota_Saida_Item where cd_produto is not null) nsi inner join
	Nota_Saida ns on nsi.cd_nota_saida = ns.cd_nota_saida inner join
	Produto p on p.cd_produto = nsi.cd_produto
	left outer join 
	Movimento_estoque me on cast(nsi.cd_nota_saida as varchar(30)) = me.cd_documento_movimento and nsi.cd_item_nota_saida = me.cd_item_documento left outer join
		Operacao_fiscal op on op.cd_operacao_fiscal = ns.cd_operacao_fiscal left outer join
		Pedido_Venda pv on pv.cd_pedido_venda = ns.cd_pedido_venda left outer join
		Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido left outer join
		Status_Nota sn on sn.cd_status_nota = ns.cd_status_nota
where
	--Filtra apenas pedidos de venda que tenham sido fechados
	IsNull(nsi.ic_movimento_estoque,'N') = 'S' and
	IsNull(tp.ic_sce_tipo_pedido,'N') = 'S' and
	((me.cd_produto <> IsNull(p.cd_produto_baixa_estoque, nsi.cd_produto))
        or
        (me.qt_movimento_estoque <> nsi.qt_item_nota_saida)) and
	--Filtro de acordo com os parametros informados
 	(((@cd_nota_saida = 0) and (ns.dt_nota_saida between @dt_inicial and @dt_final))
 	or ((@cd_nota_saida <> 0) and (nsi.cd_nota_saida = @cd_nota_saida)))
