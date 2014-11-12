
-------------------------------------------------------------------------------
--pr_grupo_fiscal_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Verificar se o produto possui grupo de produto com classificação fiscal
--Data             : 19/08/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_grupo_fiscal_produto
@cd_produto integer

as

	select 
		p.cd_produto,
		gpf.cd_classificacao_fiscal		
		
	from
		produto p 
		left outer join grupo_produto_fiscal gpf on gpf.cd_grupo_produto = p.cd_grupo_produto

	where
		cd_produto = @cd_produto and gpf.cd_classificacao_fiscal is not null
	

