
-------------------------------------------------------------------------------
--pr_resumo_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 08.07.2005
--Atualizado       : 08.07.2005
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_viagem
@dt_inicial datetime,
@dt_final   datetime
as

--select * from requisicao_viagem

select
  pv.nm_projeto_viagem                  as Projeto,
  m.nm_moeda                            as Moeda,
  max(rv.dt_fim_viagem)               as FimViagem,
  sum(isnull(rv.vl_total_viagem,0))     as Total,
  sum(isnull(rv.vl_adto_viagem,0))      as Adiantamento,
  sum(isnull(rv.vl_despesa_viagem,0))   as Despesa,
  sum(isnull(rv.vl_reembolso_viagem,0)) as Reembolso,
  sum(isnull(rv.vl_cartao_viagem,0))    as Cartao
from
  Requisicao_Viagem rv 
  left outer join Projeto_Viagem pv on pv.cd_projeto_viagem = rv.cd_projeto_viagem
  left outer join Moeda          m  on m.cd_moeda           = rv.cd_moeda
Group by
   pv.nm_projeto_viagem,
   m.nm_moeda
