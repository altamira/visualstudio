
CREATE PROCEDURE pr_depreciacao_periodo_apuracao
---------------------------------------------------------------------------
--pr_depreciacao_periodo_apuracao
---------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
---------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EGISSQL 
--Objetivo             : Consulta do Cálculo de Depreciação por Grupo de Bem
--Data                 : 10.01.2005
--Atualizado           : 
---------------------------------------------------------------------------

@cd_grupo_bem int
--@dt_inicial   datetime, -- foi verificado que não há necessidade de período
--@dt_final     datetime

as

begin

  --select * from grupo_bem
  --select * from valor_bem

  --Montagem da tabela temporia

  select
    cb.cd_bem,
    gb.cd_grupo_bem,
    year(cb.dt_calculo_bem)  as Ano,
    month(cb.dt_calculo_bem) as Mes,
    case when month(cb.dt_calculo_bem)=1  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Janeiro',
    case when month(cb.dt_calculo_bem)=2  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Fevereiro',
    case when month(cb.dt_calculo_bem)=3  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Marco',
    case when month(cb.dt_calculo_bem)=4  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Abril',
    case when month(cb.dt_calculo_bem)=5  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Maio',
    case when month(cb.dt_calculo_bem)=6  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Junho',
    case when month(cb.dt_calculo_bem)=7  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Julho',
    case when month(cb.dt_calculo_bem)=8  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Agosto',
    case when month(cb.dt_calculo_bem)=9  then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Setembro',
    case when month(cb.dt_calculo_bem)=10 then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Outubro',
    case when month(cb.dt_calculo_bem)=11 then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Novembro',
    case when month(cb.dt_calculo_bem)=12 then sum( isnull(cb.vl_calculo_bem,0) ) else 0 end as 'Dezembro',
    sum( isnull(cb.vl_calculo_bem,0) ) as Total

  into 
    #AuxCalculoBem
  from
    Calculo_Bem cb, 
    Bem b,
    Grupo_Bem gb
  where
    cb.cd_bem       = b.cd_bem             and
    b.cd_grupo_bem  = gb.cd_grupo_bem and
    gb.cd_grupo_bem = case when isnull(@cd_grupo_bem,0) = 0 then gb.cd_grupo_bem else @cd_grupo_bem end
  group by
    cb.cd_bem,
    gb.cd_grupo_bem,
    year(cb.dt_calculo_bem),
    month(cb.dt_calculo_bem)

  --Mostra a Tabela Final
  select
    gb.cd_grupo_bem              as Codigo,
    gb.nm_grupo_bem              as Grupo,
    gb.sg_grupo_bem              as Sigla,     
    gb.pc_depreciacao_grupo_bem  as PerDepreciacao,
    gb.qt_vida_util_grupo_bem    as VidaUtil,
    a.Ano                        as Ano,
    a.Janeiro                    as Janeiro,
    a.Fevereiro                  as Fevereiro,
    a.Marco                      as Marco,
    a.Abril                      as Abril,
    a.Maio                       as Maio,
    a.Junho                      as Junho,
    a.Julho                      as Julho,
    a.Agosto                     as Agosto,
    a.Setembro                   as Setembro,
    a.Outubro                    as Outubro,
    a.Novembro                   as Novembro,
    a.Dezembro                   as Dezembro,
    a.Total                      as Total                               
  from
   Grupo_Bem gb left outer join
   #AuxCalculoBem a on a.cd_grupo_bem = gb.cd_grupo_bem
  where
    gb.cd_grupo_bem = case when isnull(@cd_grupo_bem,0) = 0 then gb.cd_grupo_bem else @cd_grupo_bem end   
  order by 
    gb.nm_grupo_bem

end


