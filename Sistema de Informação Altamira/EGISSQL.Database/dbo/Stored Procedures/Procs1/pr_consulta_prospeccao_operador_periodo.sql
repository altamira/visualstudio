
-------------------------------------------------------------------------------
--pr_consulta_prospeccao_operador_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de prospeccao realizadas por período por Operador
--Data             : 14/01/2005
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_prospeccao_operador_periodo
@dt_inicial datetime,
@dt_final   datetime --,
as

--select * from cliente_prospeccao
--select * from prospeccao

select
  max(o.nm_operador_telemarketing)                      as Operador,
  isnull(count(*),0)                                    as Registro,
  isnull(count(distinct p.cd_campanha),0)               as Campanha,
  isnull(count(distinct p.cd_cliente_prospeccao),0)     as Cliente,
  email        = ( select isnull(count(ap.dt_email_prospeccao),0)    from Prospeccao ap where ap.dt_email_prospeccao    between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Visita       = ( select isnull(count(ap.dt_visita),0)              from Prospeccao ap where ap.dt_visita              between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Apresentacao = ( select isnull(count(ap.dt_apresentacao),0)        from Prospeccao ap where ap.dt_apresentacao        between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Proposta     = ( select isnull(count(ap.dt_proposta_prospeccao),0) from Prospeccao ap where ap.dt_proposta_prospeccao between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Retorno      = ( select isnull(count(ap.dt_retorno_prospeccao),0)  from Prospeccao ap where ap.dt_retorno_prospeccao  between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Fechamento   = ( select isnull(count(ap.dt_fechamento),0)          from Prospeccao ap where ap.dt_fechamento          between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing),
  Perda        = ( select isnull(count(ap.dt_perda),0)               from Prospeccao ap where ap.dt_perda               between @dt_inicial and @dt_final and ap.cd_operador_telemarketing = o.cd_operador_telemarketing)

from
  Prospeccao p left outer join
  Operador_Telemarketing o on o.cd_operador_telemarketing = p.cd_operador_telemarketing
where
  p.dt_prospeccao between @dt_inicial and @dt_final
group by
  o.cd_operador_telemarketing

