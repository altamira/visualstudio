
CREATE PROCEDURE pr_consulta_hora_analista_mes
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  --Dias uteis agenda
  select 
    year(dt_agenda)  as Ano,
    month(dt_agenda) as Mes,
    count('X') 	     as DiasUteis
  into
    #Agenda
  from 
    Agenda 
  where
    isnull(ic_util,'N') = 'S'
  group by
    year(dt_agenda),
    month(dt_agenda)

  select
    a.nm_fantasia_analista		as Analista,
    year(osa.dt_ordem_servico)		as Ano,
    month(osa.dt_ordem_servico)		as Mes,
    max(ag.DiasUteis)			as DiasUteis,
    max(ag.DiasUteis) * 8 as HorasPotenciais,
    --Cálculo das horas realizadas
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 as decimal(15,2))as HorasRealizadas,
    --Cálculo do potencial atingido
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 * 100 /
    (max(ag.DiasUteis) * 8) as decimal(15,2))as PotencialAtingido

  from
    Ordem_Servico_Analista 	osa  left outer join
    Ordem_Servico_Analista_Item osai on osa.cd_ordem_servico = osai.cd_ordem_servico left outer join
    Analista			a    on osa.cd_analista = a.cd_analista left outer join
    #Agenda			ag   on ag.Ano = year(osa.dt_ordem_servico) and ag.Mes = month(osa.dt_ordem_servico)
  group by
    a.nm_fantasia_analista,
    year(osa.dt_ordem_servico),
    month(osa.dt_ordem_servico)
  order by
    1,2,3

