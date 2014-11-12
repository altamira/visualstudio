
-------------------------------------------------------------------------------
--sp_helptext pr_comissao_motorista_previa_frota
-------------------------------------------------------------------------------
--pr_comissao_motorista_previa_frota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo da Comissão do Motorista
--                   Viagem/Frota
--Data             : 01.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_comissao_motorista_previa_frota
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from remessa_viagem
--select * from tipo_despesa_viagem
--select * from remessa_viagem_despesa

select
  m.cd_motorista,
  m.nm_motorista,
  isnull(m.pc_comissao_motorista,0.00)                                     as pc_comissao_motorista,
  sum( isnull(vl_credito_reembolso,0.00) - isnull(vl_debito_despesa,0.00)) as vl_total_motorista,
  cast(0.00 as decimal(25,2))                                              as vl_comissao_motorista
into
  #Comissao_Motorista
from 
  remessa_viagem rv                    with (nolock)
  inner join motorista m               with (nolock) on m.cd_motorista       = rv.cd_motorista
  inner join remessa_viagem_despesa rd with (nolock) on rd.cd_remessa_viagem = rv.cd_remessa_viagem
  inner join tipo_despesa_viagem td    with (nolock) on td.cd_despesa_viagem = rd.cd_tipo_despesa_viagem
where
  rv.dt_fechamento_viagem between @dt_inicial and @dt_final and
  isnull(rv.cd_motorista,0)>0 and
  isnull(td.ic_comissao_motorista,'N') = 'S' 

group by
  m.cd_motorista,
  m.nm_motorista,
  m.pc_comissao_motorista

--Cálculo da Comissão

update
  #Comissao_Motorista
set
  vl_comissao_motorista = round( cast(vl_total_motorista * (pc_comissao_motorista/100 ) as decimal(25,2)),2)


select
  *
from
  #Comissao_Motorista
order by
  nm_motorista

