
-------------------------------------------------------------------------------
--pr_resumo_apropriacao_icms_ciap
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Apropriação do CIAP
--Data             : 08.11.2006
--Alteração        : 08/11/2006 - Incluído Isnull na condição where - Daniel C neto
--                 : 
------------------------------------------------------------------------------
create procedure pr_resumo_apropriacao_icms_ciap
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@cd_planta          int      = 0,
@cd_localizacao_bem int      = 0

as

--select * from ciap
--select * from ciap_composicao
--select * from ciap_demonstrativo
  
select
  cd.qt_ano                                                            as Ano,
  sum(case when cd.qt_mes = 01 then isnull(cd.vl_icms,0) else 0.00 end) as Janeiro,
  sum(case when cd.qt_mes = 02 then isnull(cd.vl_icms,0) else 0.00 end) as Fevereiro,
  sum(case when cd.qt_mes = 03 then isnull(cd.vl_icms,0) else 0.00 end) as Marco,
  sum(case when cd.qt_mes = 04 then isnull(cd.vl_icms,0) else 0.00 end) as Abril,
  sum(case when cd.qt_mes = 05 then isnull(cd.vl_icms,0) else 0.00 end) as Maio,
  sum(case when cd.qt_mes = 06 then isnull(cd.vl_icms,0) else 0.00 end) as Junho,
  sum(case when cd.qt_mes = 07 then isnull(cd.vl_icms,0) else 0.00 end) as Julho,
  sum(case when cd.qt_mes = 08 then isnull(cd.vl_icms,0) else 0.00 end) as Agosto,
  sum(case when cd.qt_mes = 09 then isnull(cd.vl_icms,0) else 0.00 end) as Setembro,
  sum(case when cd.qt_mes = 10 then isnull(cd.vl_icms,0) else 0.00 end) as Outubro,
  sum(case when cd.qt_mes = 11 then isnull(cd.vl_icms,0) else 0.00 end) as Novembro,
  sum(case when cd.qt_mes = 12 then isnull(cd.vl_icms,0) else 0.00 end) as Dezembro,
  sum(isnull(cd.vl_icms,0))                                             as Total,
  max(p.nm_planta)                                                      as Planta,
  max(l.nm_localizacao_bem)                                             as Localizacao
  
--select * from localizacao_bem

into
  #Resumo_Ciap

from
  Ciap c
  left outer join Bem b                 on b.cd_bem                = c.cd_bem
  left outer join Ciap_Demonstrativo cd on cd.cd_ciap              = c.cd_ciap
  left outer join Planta p              on p.cd_planta             = b.cd_planta
  left outer join Localizacao_bem l     on l.cd_localizacao_bem    = b.cd_localizacao_bem
where
  IsNull(b.cd_planta,0)          = case when @cd_planta          = 0 then IsNull(b.cd_planta,0)          else @cd_planta          end and
  IsNull(b.cd_localizacao_bem,0) = case when @cd_localizacao_bem = 0 then IsNull(b.cd_localizacao_bem,0) else @cd_localizacao_bem end and
  cd.qt_ano              between year(@dt_inicial) and year(@dt_final)
group by
  cd.qt_ano
 
declare @vl_total decimal(25,2)

select 
  @vl_total = sum(isnull(Total,0))
from
  #Resumo_Ciap

select
  *,
  Perc = (Total/@vl_total)*100
from
  #Resumo_Ciap

order by Ano desc


