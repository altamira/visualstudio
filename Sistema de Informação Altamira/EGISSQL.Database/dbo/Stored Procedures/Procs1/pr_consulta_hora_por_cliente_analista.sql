
CREATE PROCEDURE pr_consulta_hora_por_cliente_analista
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  select
    c.nm_fantasia_cliente		as Cliente,
    a.nm_fantasia_analista		as Analista,

    --Cálculo das horas realizadas
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 as decimal(15,2))as HorasRealizadas

  from
    Ordem_Servico_Analista 	osa  left outer join
    Ordem_Servico_Analista_Item osai on osa.cd_ordem_servico = osai.cd_ordem_servico left outer join
    Cliente 			c    on osa.cd_cliente = c.cd_cliente left outer join
    Analista			a    on osa.cd_analista = a.cd_analista
  where
    osa.dt_ordem_servico between @dt_inicial and @dt_final
  group by
    c.nm_fantasia_cliente,
    a.nm_fantasia_analista
  order by
    1 asc, 3 desc

