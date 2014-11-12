
-------------------------------------------------------------------------------
--pr_aplicacacao_proposta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_aplicacacao_proposta
@cd_aplicacao_produto int = 0,
@dt_inicial datetime,
@dt_final   datetime

as

select
  ap.cd_aplicacao_produto,
  ap.nm_aplicacao_produto,
  c.cd_consulta,
  c.dt_consulta

from
  Consulta c
  left outer join Aplicacao_Produto ap on ap.cd_aplicacao_produto = c.cd_aplicacao_produto
where
  c.cd_aplicacao_produto = case when @cd_aplicacao_produto = 0 then c.cd_aplicacao_produto else @cd_aplicacao_produto end and
  c.dt_consulta between @dt_inicial and @dt_final

