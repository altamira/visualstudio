
--sp_helptext pr_orcamento_financeiro_anual
-------------------------------------------------------------------------------
--pr_orcamento_financeiro_anual
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Valores do Orçamento do Plano Financeiro
--                   por Ano 
--Data             : 15.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_orcamento_financeiro_anual
@cd_ano             int = 0,
@ic_tipo_orcamento  int = 0
as

--select * from plano_financeiro
--select * from orcamento_financeiro
--update plano_financeiro set cd_procedimento = 312 where cd_plano_financeiro = 1

--Valor Orçado

if @ic_tipo_orcamento = 1
begin
  select
    pf.cd_plano_financeiro       as cd_plano_financeiro,
    pf.nm_conta_plano_financeiro as PlanoFinanceiro,
    pf.cd_mascara_plano_financeiro,
    case when isnull(o.cd_ano,0)=0 then @cd_ano else o.cd_ano end                        as Ano,
    sum(case when o.cd_mes = 01 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Janeiro,
    sum(case when o.cd_mes = 02 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Fevereiro,
    sum(case when o.cd_mes = 03 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Marco,
    sum(case when o.cd_mes = 04 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Abril,
    sum(case when o.cd_mes = 05 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Maio,
    sum(case when o.cd_mes = 06 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Junho,
    sum(case when o.cd_mes = 07 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Julho,
    sum(case when o.cd_mes = 08 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Agosto,
    sum(case when o.cd_mes = 09 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Setembro,
    sum(case when o.cd_mes = 10 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Outubro,
    sum(case when o.cd_mes = 11 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Novembro,
    sum(case when o.cd_mes = 12 then isnull(o.vl_orcamento_financeiro,0) else 0.00 end ) as Dezembro,
    sum(isnull(o.vl_orcamento_financeiro,0))                                             as Total,
    max(pf.cd_procedimento)                                                              as cd_procedimento,
    max(p.nm_procedimento)                                                               as Procedimento,
    max(p.nm_sql_procedimento)                                                           as Sql
 
   from 
     Plano_Financeiro pf
     left outer join Orcamento_Financeiro o on pf.cd_plano_financeiro = o.cd_plano_financeiro
     left outer join egisadmin.dbo.Procedimento p on p.cd_procedimento = pf.cd_procedimento
  where
    isnull(pf.ic_conta_orcamento,'S') = 'S'
  group by
    o.cd_ano,
    pf.cd_plano_financeiro,
    pf.cd_mascara_plano_financeiro,
    pf.nm_conta_plano_financeiro
  order by
    pf.cd_mascara_plano_financeiro

end

--select * from egisadmin.dbo.procedimento

--Valor Realizado

if @ic_tipo_orcamento = 2
begin
  select
    pf.cd_plano_financeiro       as cd_plano_financeiro,
    pf.nm_conta_plano_financeiro as PlanoFinanceiro,
    pf.cd_mascara_plano_financeiro,
    case when isnull(o.cd_ano,0)=0 then @cd_ano else o.cd_ano end                        as Ano,
    sum(case when o.cd_mes = 01 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Janeiro,
    sum(case when o.cd_mes = 02 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Fevereiro,
    sum(case when o.cd_mes = 03 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Marco,
    sum(case when o.cd_mes = 04 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Abril,
    sum(case when o.cd_mes = 05 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Maio,
    sum(case when o.cd_mes = 06 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Junho,
    sum(case when o.cd_mes = 07 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Julho,
    sum(case when o.cd_mes = 08 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Agosto,
    sum(case when o.cd_mes = 09 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Setembro,
    sum(case when o.cd_mes = 10 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Outubro,
    sum(case when o.cd_mes = 11 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Novembro,
    sum(case when o.cd_mes = 12 then isnull(o.vl_realizado_financeiro,0) else 0.00 end ) as Dezembro,
    sum(isnull(o.vl_realizado_financeiro,0))                                             as Total,
    max(pf.cd_procedimento)                                                              as cd_procedimento, 
    max(p.nm_procedimento)                                                               as Procedimento,
    max(p.nm_sql_procedimento)                                                           as Sql
   into
     #Realizado 
   from 
     Plano_Financeiro pf
     left outer join Orcamento_Financeiro o on pf.cd_plano_financeiro = o.cd_plano_financeiro
     left outer join egisadmin.dbo.Procedimento p on p.cd_procedimento = pf.cd_procedimento
  where
    isnull(pf.ic_conta_orcamento,'S') = 'S'
  group by
    o.cd_ano,
    pf.cd_plano_financeiro,
    pf.cd_mascara_plano_financeiro,
    pf.nm_conta_plano_financeiro
  order by
    pf.cd_mascara_plano_financeiro

  declare @sql varchar(8000)
  declare @vl_total_mes float
  --set @sql = 'pr_total_vendas_periodo '+'''01/01/2006'''+','+'''01/31/2006'''
  set @sql = 'total_ccf'
  execute @sql @vl_total_mes output

  --select @vl_total_mes

   update
     #Realizado
   set
     Janeiro = @vl_total_mes
   where
     isnull(cd_procedimento,0)>0

  --Desenvolver um while com data inicial e final para atualização dos Valores


  --Apresentação do Resultado

  select * from #Realizado
  order by
    cd_mascara_plano_financeiro

end


