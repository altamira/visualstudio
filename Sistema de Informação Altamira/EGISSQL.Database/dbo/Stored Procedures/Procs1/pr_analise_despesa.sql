
-------------------------------------------------------------------------------
--pr_analise_despesa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Ocorrências no Controle Operacional
--                   Análise de Despesas 
--Data             : 01/10/2003
--Atualizado       : 20.08.2005
--------------------------------------------------------------------------------
create procedure pr_analise_despesa
@dt_inicial datetime,
@dt_final   datetime
as

--select * from movimento_veiculo
--select * from veiculo
--select 

select
  d.nm_despesa_veiculo                      as Despesa,
 tsv.nm_tipo_servico_veiculo                as Servico, 
  sum( isnull( mv.qt_movimento_veiculo,0) ) as Qtd,
  sum( isnull( mv.qt_movimento_veiculo,0) * isnull( mv.vl_movimento_veiculo,0) ) as Total
into #MovimentoVeiculo
from
  Movimento_Veiculo mv
  left outer join Despesa_Veiculo d        on d.cd_despesa_veiculo  = mv.cd_despesa_veiculo
  left outer join Tipo_Servico_Veiculo tsv on tsv.cd_tipo_servico_veiculo = mv.cd_tipo_servico_veiculo
where
  mv.dt_movimento_veiculo between @dt_inicial and @dt_final
Group by 
  d.nm_despesa_veiculo,
  tsv.nm_tipo_servico_veiculo

declare @vl_total float

set @vl_total = 0

select @vl_total = sum( isnull(total,0) ) from #MovimentoVeiculo

select
  *,
  Perc = (Total/@vl_total)*100
from
  #MovimentoVeiculo
  
