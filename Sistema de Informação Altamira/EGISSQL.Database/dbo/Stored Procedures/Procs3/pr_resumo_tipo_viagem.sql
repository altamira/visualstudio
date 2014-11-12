
-------------------------------------------------------------------------------
--pr_resumo_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Rafael Santiago
--Banco de Dados   : EgisSQL
--Objetivo         : Mostra o Valor Total das Requisições de Viagem
--Data             : 08.07.2005
--Atualizado       : 28.12.2007
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_tipo_viagem
@dt_inicial datetime,
@dt_final   datetime
as

-- select * from Tipo_viagem
-- select * from Requisicao_viagem

select
  tv.nm_tipo_viagem                     as TipoViagem,
  
  --sum(isnull(rv.vl_total_viagem,0))     as Total,
  sum(isnull(rv.vl_adto_viagem,0))     as Total,
  sum(isnull(sa.vl_adiantamento,0))     as Adiantamento

  --Totais da Prestação de Contas ( Complementar )

from
  Requisicao_Viagem rv with (nolock)
  left outer join Tipo_Viagem tv              on tv.cd_tipo_viagem = rv.cd_tipo_viagem
  left outer join Solicitacao_Adiantamento sa on sa.cd_requisicao_viagem = rv.cd_requisicao_viagem
Group by
  tv.nm_tipo_viagem
