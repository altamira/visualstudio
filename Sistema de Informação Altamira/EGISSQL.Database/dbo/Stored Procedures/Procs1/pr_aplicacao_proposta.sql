
-------------------------------------------------------------------------------
--pr_aplicacao_proposta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--		   : Vagner do Amaral
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de proposta por aplicação
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--		   : 18/08/2005
--------------------------------------------------------------------------------------------------
create procedure pr_aplicacao_proposta
@cd_aplicacao_produto int = 0,
@dt_inicial datetime,
@dt_final   datetime

as

select
  c.cd_consulta,
  c.dt_consulta,
  c.cd_vendedor,
  c.vl_total_consulta,
  ap.cd_aplicacao_produto,
  ap.nm_aplicacao_produto,
  ve.nm_fantasia_vendedor,
  cl.nm_fantasia_cliente,
  ci.cd_item_consulta,	
  ci.nm_fantasia_produto,
  ci.qt_item_consulta,
  ci.vl_unitario_item_consulta,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  p.ds_produto
  
from
  	Consulta c
	left outer join Aplicacao_Produto ap 	on ap.cd_aplicacao_produto  = c.cd_aplicacao_produto
	left outer join Vendedor ve          	on ve.cd_vendedor           = c.cd_vendedor
	left outer join Cliente cl		on cl.cd_cliente	    = c.cd_cliente
	left outer join consulta_itens ci	on c.cd_consulta	    = ci.cd_consulta
	left outer join produto p		on p.cd_produto		    = ci.cd_produto
	   
where
  c.cd_aplicacao_produto = case when isnull(@cd_aplicacao_produto,0) = 0 
				then isnull(c.cd_aplicacao_produto,0) 
				else @cd_aplicacao_produto 
				end 
  				and c.dt_consulta between @dt_inicial and @dt_final

