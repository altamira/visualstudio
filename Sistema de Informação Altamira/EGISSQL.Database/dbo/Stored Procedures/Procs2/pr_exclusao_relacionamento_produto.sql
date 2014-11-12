
--------------------------------------------------------------------------------
--pr_valida_exclusao_campo
--------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA                                     2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server  2000
--Autor(es)		: Márcio Rodrigues.
--Banco de Dados	: EGISSQL
--Objetivo		: Exclui o produtos das tabelas relacionadas
--Data			: 15/06/2005
----------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_exclusao_relacionamento_produto
@cd_produto int = -1
as

--------------------------------------------------------------------------------
--DELETA PRODUTO_CUSTO
--------------------------------------------------------------------------------
	DELETE FROM Produto_Custo
	WHERE cd_produto = @cd_produto

--------------------------------------------------------------------------------
--DELETA PRODUTO_SALDO
--------------------------------------------------------------------------------
	DELETE FROM Produto_Saldo
	WHERE cd_produto = @cd_produto


