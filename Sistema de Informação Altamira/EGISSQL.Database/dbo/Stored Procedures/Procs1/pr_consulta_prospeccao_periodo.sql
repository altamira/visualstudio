
-------------------------------------------------------------------------------
--pr_consulta_prospeccao_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de prospeccao realizadas por período
--Data             : 14/01/2005
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_prospeccao_periodo
@dt_inicial datetime,
@dt_final   datetime --,
as

--select * from cliente_prospeccao
--select * from prospeccao

select
  dt_prospeccao                                       as Data,
  isnull(count(*),0)                                  as Registro,
  isnull(count(distinct cd_operador_telemarketing),0) as Operador,
  isnull(count(distinct cd_campanha),0)               as Campanha,
  isnull(count(distinct cd_cliente_prospeccao),0)     as Cliente,
  email        = ( select isnull(count(dt_email_prospeccao),0)    from Prospeccao where dt_email_prospeccao    between @dt_inicial and @dt_final ),
  Visita       = ( select isnull(count(dt_visita),0)              from Prospeccao where dt_visita              between @dt_inicial and @dt_final ),
  Apresentacao = ( select isnull(count(dt_apresentacao),0)        from Prospeccao where dt_apresentacao        between @dt_inicial and @dt_final ),
  Proposta     = ( select isnull(count(dt_proposta_prospeccao),0) from Prospeccao where dt_proposta_prospeccao between @dt_inicial and @dt_final ),
  Retorno      = ( select isnull(count(dt_retorno_prospeccao),0)  from Prospeccao where dt_retorno_prospeccao  between @dt_inicial and @dt_final ),
  Fechamento   = ( select isnull(count(dt_fechamento),0)          from Prospeccao where dt_fechamento          between @dt_inicial and @dt_final ),
  Perda        = ( select isnull(count(dt_perda),0)               from Prospeccao where dt_perda               between @dt_inicial and @dt_final )

from
  Prospeccao
where
  dt_prospeccao between @dt_inicial and @dt_final
group by
  dt_prospeccao

