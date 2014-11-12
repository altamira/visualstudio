
CREATE PROCEDURE pr_consulta_hora_cliente_mes
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  select
    c.nm_fantasia_cliente		as Cliente,
    year(osa.dt_ordem_servico)		as Ano,
    month(osa.dt_ordem_servico)		as Mes,
    --Cálculo das horas realizadas
    cast(sum(datediff(n,convert(DateTime, osai.nm_hora_inicio_ordem), 
                   convert(DateTime, osai.nm_hora_fim_ordem)))/60.00 as decimal(15,2))as HorasRealizadas

  from
    Ordem_Servico_Analista 	osa  left outer join
    Ordem_Servico_Analista_Item osai on osa.cd_ordem_servico = osai.cd_ordem_servico left outer join
    Cliente 			c    on osa.cd_cliente = c.cd_cliente
  group by
    c.nm_fantasia_cliente,
    year(osa.dt_ordem_servico),
    month(osa.dt_ordem_servico)
  order by
    1,2,3

