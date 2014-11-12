create procedure pr_analise_producao_operador
---------------------------------------------------
--GBS - Global Business Sollution              2004
--Stored Procedure: Microsoft SQL Server       2004
--Banco de Dados: Sql Server 2000
--Autor: Igor Augusto C. Gama
--Data: 21.06.2004
--Objetivo: Listar dados de horas do operador
---------------------------------------------------
 @cd_parametro int = 1,
 @cd_operador int,
 @dt_inicial Datetime,
 @dt_final DateTime
as

  set @cd_parametro = isnull(@cd_parametro,0)

  declare
    @qt_hora_diaria_agenda float,
    @qt_hora_mes_agenda float,
    @qt_capacidade float

  --Pega a quantidade de horas no mês
  Select
    @qt_hora_diaria_agenda  = qt_hora_diaria_agenda,
    @qt_hora_mes_agenda = qt_hora_mes_agenda
  From
    Parametro_agenda
  Where 
    cd_empresa = dbo.fn_empresa()

  --Cálculo de Capacidade
  select @qt_capacidade = (dbo.fn_GetQtdDiaUtilPeriodo(@dt_inicial, @dt_final, 'U') * @qt_hora_diaria_agenda)

  select
    o.cd_operador,
    o.nm_operador,
    o.nm_fantasia_operador,
    @qt_capacidade as 'qt_capacidade',
    sum(ppa.qt_trabalho_efetivo) as 'qt_trabalho_efetivo',
   case when @qt_capacidade - sum(qt_trabalho_efetivo) > 0
         then @qt_capacidade - sum(qt_trabalho_efetivo)
         else 0
    end as 'qt_ociosidade', 
    case when @qt_capacidade - sum(qt_trabalho_efetivo) < 0
         then @qt_capacidade - sum(qt_trabalho_efetivo)
         else 0
    end as 'qt_hora_extra',
    sum(mo.qt_movimento_operador) as 'qt_movimento_operador',
    count(ppa.cd_processo) as 'qt_processo',
    o.cd_chapa_operador,
    dep.nm_departamento,
    o.nm_cargo_operador,
    o.nm_funcao_operador
  into
    #tabela
  from
    operador o
      left outer join
    egisadmin.dbo.departamento dep
      on o.cd_departamento = dep.cd_departamento
      left outer join
    (select cd_operador, cd_processo, dt_processo_apontamento,
            (cast(datepart(hh, cast(hr_final_apontamento as datetime)) as float) + 
             (cast(datepart(mi, cast(hr_final_apontamento as datetime)) as float) /60)) -
            (cast(datepart(hh, cast(hr_inicial_apontamento as datetime)) as float) + 
             (cast(datepart(mi, cast(hr_inicial_apontamento as datetime)) as float) /60)) as 'qt_trabalho_efetivo'
     from processo_producao_apontamento) ppa
      on o.cd_operador = ppa.cd_operador
      left outer join
    (select mo.cd_operador, 
       case so.ic_tipo_status_operador 
         when 'S' then mo.qt_movimento_operador * -1
         when 'N' then mo.qt_movimento_operador * 0
         else mo.qt_movimento_operador
       end as 'qt_movimento_operador'
     from 
       movimento_operador mo
         left outer join
       status_operador so
         on mo.cd_status_operador = so.cd_status_operador) mo
      on o.cd_operador = mo.cd_operador
  where
    ppa.cd_operador = case when @cd_operador = 0 then ppa.cd_operador
                           else @cd_operador end 
    and ppa.dt_processo_apontamento between @dt_inicial and @dt_final
  group by
    o.cd_operador,
    o.nm_operador,
    o.nm_fantasia_operador,
    o.cd_chapa_operador,
    o.nm_funcao_operador,
    o.nm_cargo_operador,
    dep.nm_departamento

  --Somente para mostrar o total no componente grid report para o relatório
  if @cd_parametro = 2
  Begin
     --inserir uma linha para separar o total
    insert into #tabela
    select 
      99998 as 'cd_operador',
      '' as 'nm_operador',
      '' as 'nm_fantasia_operador',
      null as 'qt_capacidade',
      null as 'qt_trabalho_efetivo',
      null as 'qt_ociosidade', 
      null as 'qt_hora_extra',
      null as 'qt_movimento_operador',
      null as 'qt_processo',
      '' as 'cd_chapa_operador',
      null as 'nm_departamento',
      null as 'nm_cargo_operador',
      null as 'nm_funcao_operador'
    --inserindo os totais
    insert into #Tabela
    select
      99999 as 'cd_operador',
      'Total' as 'nm_operador',
      'Total' as 'nm_fantasia_operador',
      sum(@qt_capacidade) as 'qt_capacidade',
      sum(qt_trabalho_efetivo) as 'qt_trabalho_efetivo',
      sum(qt_ociosidade) as 'qt_ociosidade', 
      sum(qt_hora_extra) as 'qt_hora_extra',
      sum(qt_movimento_operador) as 'qt_movimento_operador',
      sum(qt_processo) as 'qt_processo',
      '' as 'cd_chapa_operador',
      '' as 'nm_departamento',
      '' as 'nm_cargo_operador',
      '' as 'nm_funcao_operador'
    from
      #Tabela
   end

  --Apresentar o resultado da pesquisa
  Select * from #Tabela
  order by cd_operador

