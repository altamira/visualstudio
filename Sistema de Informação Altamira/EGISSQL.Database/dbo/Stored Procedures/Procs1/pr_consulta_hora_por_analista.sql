
CREATE PROCEDURE pr_consulta_hora_por_analista
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  declare @qt_dia_util int

  --Pegando quantidade de dias úteis
  select 
    @qt_dia_util = count('X')
  from 
    Agenda 
  where 
    dt_agenda between @dt_inicial and @dt_final and
    isnull(ic_util,'N') = 'S'

  select
    a.nm_fantasia_analista		as Analista,
    @qt_dia_util 			as DiasUteis,
    @qt_dia_util * 8 			as HorasPotencial,

    --Cálculo das horas realizadas
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 as decimal(15,2))as HorasRealizadas,

    --Cálculo do potencial atingido
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 * 100 /
    (@qt_dia_util * 8) as decimal(15,2))as PotencialAtingido
  from
    Ordem_Servico_Analista 	osa  left outer join
    Ordem_Servico_Analista_Item osai on osa.cd_ordem_servico = osai.cd_ordem_servico left outer join
    Analista			a    on osa.cd_analista = a.cd_analista
  where
    osa.dt_ordem_servico between @dt_inicial and @dt_final
  group by
    a.nm_fantasia_analista
  order by
    4 desc

