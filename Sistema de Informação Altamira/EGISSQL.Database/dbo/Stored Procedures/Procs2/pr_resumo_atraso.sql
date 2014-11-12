
create procedure pr_resumo_atraso

as

  declare @vl_total float

-- Verificação da tabela de Parâmetro de Análise do SCR
  select
    qt_inicial,
    qt_final,
    cd_parametro_analise_scr,    
    nm_parametro_analise_scr,
    qt_ordem
  into
    #Periodo
  from
    Parametro_Analise_SCR      

  --select * from #Periodo

--Montagem do Arquivo com os Valores por Dia

  select
    cast( (GetDate() - dr.dt_vencimento_documento)-1 as integer) as 'DiasAtraso',
    isnull(sum(dr.vl_saldo_documento),0)                         as 'Valor'
  Into #Documento
  from
    Documento_receber dr
  where
    isnull(dr.vl_saldo_documento,0) > 0     and
    dr.dt_vencimento_documento is not null  and
    dr.dt_vencimento_documento < getdate()
  group by 
     dr.dt_vencimento_documento 
  order by
    1

  --select * from #Documento

  --Valores por Dia de Atraso
  select
    p.cd_parametro_analise_scr,
    sum(d.Valor) as 'Valor'
  into #Tabela_Final
  from
    #Periodo p inner join
    #Documento d on d.DiasAtraso between p.qt_inicial and p.qt_final
  group by
    p.cd_parametro_analise_scr

  set @vl_total = ( select sum(isnull(Valor,0)) from #Tabela_Final)

  select 
     t.*,
     p.nm_parametro_analise_scr,
    ((t.Valor * 100) / @vl_total ) as 'perc'
  from
    #Tabela_Final t left outer join
    #Periodo p on p.cd_parametro_analise_scr = t.cd_parametro_analise_scr
  order by
    p.qt_ordem

