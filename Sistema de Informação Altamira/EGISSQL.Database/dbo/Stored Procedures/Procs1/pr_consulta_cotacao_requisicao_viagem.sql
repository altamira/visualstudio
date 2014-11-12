
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cotacao_requisicao_viagem
-------------------------------------------------------------------------------
--pr_consulta_cotacao_requisicao_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Itens que necessitam de Cotação 
--                   Requisição de Viagem
--Data             : 31.08.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_cotacao_requisicao_viagem
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from categoria_viagem
--select * from requisicao_viagem
--select * from requisicao_viagem_composicao

select
  cv.nm_categoria_viagem,
  rvc.qt_item_viagem,
  f.nm_funcionario,
  tv.nm_tipo_viagem,
  rv.cd_requisicao_viagem,
  rv.dt_requisicao_viagem,
  rv.cd_tipo_viagem,
  rv.cd_funcionario,
  rv.nm_local_viagem
from
  Requisicao_Viagem rv with (nolock)
  inner join requisicao_viagem_composicao rvc with (nolock) on rvc.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left outer join categoria_viagem cv         with (nolock) on cv.cd_categoria_viagem   = rvc.cd_categoria_viagem
  left outer join funcionario      f          with (nolock) on f.cd_funcionario         = rv.cd_funcionario
  left outer join Tipo_Viagem      tv         with (nolock) on tv.cd_tipo_viagem        = rv.cd_tipo_viagem
where
  rv.dt_requisicao_viagem between @dt_inicial and @dt_final
  and isnull(cv.ic_cotacao_categoria_viagem,'N')='S'

order by
  rv.dt_requisicao_viagem,
  cv.nm_categoria_viagem

