
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_evento_folha
-------------------------------------------------------------------------------
--pr_consulta_evento_folha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Eventos da Folha de Pagamento
--Data             : 14.06.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_evento_folha
@ic_parametro int        = 0,
@cd_evento    int        = 0,
@nm_evento    varchar(40)=''
as

--select * from evento_folha
--select * from plano_financeiro
--select * from evento_incidencia

if @ic_parametro = 1
begin
  select
    e.cd_evento,
    e.nm_evento,
    e.sg_evento,
    e.vl_fator_evento,
    e.nm_obs_evento,
    te.nm_tipo_evento,
    ne.nm_natureza_evento,
    tce.nm_tipo_calculo_evento,
    pf.cd_mascara_plano_financeiro,
    pf.nm_conta_plano_financeiro,
    pc.nm_conta,
    pc.cd_conta_reduzido,
    pc.cd_mascara_conta

  from
    Evento_Folha e                          with (nolock)  
    left outer join tipo_evento te          with (nolock) on te.cd_tipo_evento          = e.cd_tipo_evento
    left outer join natureza_evento     ne  with (nolock) on ne.cd_natureza_evento      = e.cd_natureza_evento
    left outer join tipo_calculo_evento tce with (nolock) on tce.cd_tipo_calculo_evento = e.cd_tipo_calculo_evento
    left outer join plano_financeiro    pf  with (nolock) on pf.cd_plano_financeiro     = e.cd_plano_financeiro
    left outer join plano_conta         pc  with (nolock) on pc.cd_conta                = e.cd_conta

  --select * from tipo_evento
  --select * from plano_conta

  order by
    nm_evento


end

if @ic_parametro = 2
begin
  --select * from incidencia_calculo
  select
    e.cd_evento,
    e.nm_evento,
    ic.cd_incidencia_calculo,
    ic.nm_incidencia_calculo,
    ic.sg_incidencia_calculo,
    ic.nm_obs_incidencia_calculo    
  from
    evento_folha e
    inner join evento_incidencia ei  on ei.cd_evento             = e.cd_evento
    inner join incidencia_calculo ic on ic.cd_incidencia_calculo = ei.cd_incidencia_calculo
  where
    e.cd_evento = case when @cd_evento = 0 then e.cd_evento else @cd_evento end

end

