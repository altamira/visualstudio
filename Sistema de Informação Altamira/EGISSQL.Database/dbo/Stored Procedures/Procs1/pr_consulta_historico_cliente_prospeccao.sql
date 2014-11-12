
CREATE PROCEDURE pr_consulta_historico_cliente_prospeccao

@ic_filtro        char(1), 
@dt_inicial       datetime,
@dt_final         datetime

AS

SELECT     ph.dt_prospeccao_historico, 
           ph.dt_historico_retorno, 
           ph.dt_real_retorno, 
           cp.nm_fantasia_cliente, 
           v.nm_fantasia_vendedor, 
           cpc.nm_fantasia_contato, 
           ph.nm_assunto_prospeccao,
           fc.nm_cliente_fase,
      	   ph.ds_historico_Prospeccao

into #Selecao

FROM       Prospeccao_Historico ph left outer join
           Prospeccao p ON ph.cd_prospeccao = p.cd_prospeccao left outer join
           Cliente_Prospeccao cp ON p.cd_cliente_prospeccao = cp.cd_cliente_prospeccao left outer join
           Cliente_Fase fc on fc.cd_cliente_fase = ph.cd_cliente_fase left outer join
           Vendedor v ON ph.cd_vendedor = v.cd_vendedor left outer join
           Cliente_Prospeccao_Contato cpc ON p.cd_cliente_prospeccao = cpc.cd_cliente_prospeccao AND ph.cd_prospeccao_contato = cpc.cd_prospeccao_contato

where 
   ((ph.dt_prospeccao_historico between @dt_inicial and @dt_final) and
    (@ic_filtro = 'L')) or
   ((ph.dt_historico_retorno between @dt_inicial and @dt_final) and
    (@ic_filtro = 'P')) or
   ((ph.dt_real_retorno between @dt_inicial and @dt_final) and
    (@ic_filtro = 'R'))


if @ic_filtro = 'L'
  select * from #Selecao order by dt_prospeccao_historico desc
else if @ic_filtro = 'P'
  select * from #Selecao order by dt_historico_retorno desc 
else if @ic_filtro = 'R'
  select * from #Selecao order by dt_real_retorno desc 

