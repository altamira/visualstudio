
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_producao_geral
-------------------------------------------------------------------------------
--pr_resumo_producao_geral
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo Produção Geral
--
--Data             : 03.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_resumo_producao_geral
@ic_parametro     int      = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_local_maquina int      = 0

as

--select * from maquina

------------------------------------------------------------------------------
--Corredor/Local da Máquina
------------------------------------------------------------------------------

if @ic_parametro = 0
begin

  select
    m.cd_local_maquina,
    max(l.nm_local_maquina)     as nm_local_maquina,
    count(*)                    as qt_maquina

--     max(m.cd_maquina)           as cd_maquina,
--     max(m.nm_fantasia_maquina)  as nm_fantasia_maquina,
--     max(m.nm_maquina)           as nm_maquina,
--     max(m.sg_maquina)           as sg_maquina,
--     max(m.qt_agulhagem_maquina) as qt_agulhagem_maquina
     
  from
    maquina m 
    left outer join local_maquina l on l.cd_local_maquina = m.cd_local_maquina
  group by
    m.cd_local_maquina     
  order by
    l.nm_local_maquina

end

if @ic_parametro = 1
begin

  select
    m.cd_local_maquina,
    l.nm_local_maquina     as nm_local_maquina,
    m.cd_maquina           as cd_maquina,
    m.nm_fantasia_maquina  as nm_fantasia_maquina,
    m.nm_maquina           as nm_maquina,
    m.sg_maquina           as sg_maquina,
    m.qt_agulhagem_maquina as qt_agulhagem_maquina
     
  from
    maquina m 
    left outer join local_maquina l on l.cd_local_maquina = m.cd_local_maquina
  where
    m.cd_local_maquina = case when @cd_local_maquina = 0 then m.cd_local_maquina else @cd_local_maquina end
  order by
    m.nm_fantasia_maquina
    

end

