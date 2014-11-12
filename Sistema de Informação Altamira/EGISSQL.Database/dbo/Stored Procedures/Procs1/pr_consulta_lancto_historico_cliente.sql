
CREATE PROCEDURE pr_consulta_lancto_historico_cliente

@ic_filtro        char(1), 
@dt_inicial       datetime,
@dt_final         datetime

AS

SELECT     ch.dt_historico_lancamento, 
           ch.dt_historico_retorno, 
           ch.dt_real_retorno, 
           c.nm_fantasia_cliente, 
           v.nm_fantasia_vendedor, 
           cc.nm_fantasia_contato, 
           ch.nm_assunto,
           fc.nm_cliente_fase,
	   ch.ds_historico_lancamento

into #Selecao

FROM       Cliente_Historico ch left outer join
           Cliente c ON ch.cd_cliente = c.cd_cliente left outer join
           Cliente_Fase fc on fc.cd_cliente_fase = ch.cd_cliente_fase left outer join
           Vendedor v ON ch.cd_vendedor = v.cd_vendedor left outer join
           Cliente_Contato cc ON ch.cd_cliente = cc.cd_cliente AND ch.cd_contato = cc.cd_contato

where 
   ((ch.dt_historico_lancamento between @dt_inicial and @dt_final) and
    (@ic_filtro = 'L')) or
   ((ch.dt_historico_retorno between @dt_inicial and @dt_final) and
    (@ic_filtro = 'P')) or
   ((ch.dt_real_retorno between @dt_inicial and @dt_final) and
    (@ic_filtro = 'R'))


if @ic_filtro = 'L'
  select * from #Selecao order by dt_historico_lancamento desc
else if @ic_filtro = 'P'
  select * from #Selecao order by dt_historico_retorno desc 
else if @ic_filtro = 'R'
  select * from #Selecao order by dt_real_retorno desc 

