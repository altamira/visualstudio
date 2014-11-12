
-----------------------------------------------------------------------------------
--pr_historico_balanco_patrimonial
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Consulta do Histórcio do Balanço Patrimonial
--Data                : 30.12.2004
--Atualizado          : 
-----------------------------------------------------------------------------------
create procedure pr_historico_balanco_patrimonial
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_grau_conta int
declare @qt_mes        int --Quantidade de Meses


set @qt_mes = month( @dt_final ) - month( @dt_inicial )

--select @qt_mes + 1

--Carregar Dados da Tabela Parâmetro Contábil

set @qt_grau_conta = 3 --

--select * from saldo_conta

select
  sc.cd_conta,
  case when month(sc.dt_saldo_conta) =  1 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Janeiro',
  case when month(sc.dt_saldo_conta) =  2 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Fevereiro',
  case when month(sc.dt_saldo_conta) =  3 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Março',
  case when month(sc.dt_saldo_conta) =  4 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Abril',
  case when month(sc.dt_saldo_conta) =  5 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Maio',
  case when month(sc.dt_saldo_conta) =  6 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Junho',
  case when month(sc.dt_saldo_conta) =  7 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Julho',
  case when month(sc.dt_saldo_conta) =  8 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Agosto',
  case when month(sc.dt_saldo_conta) =  9 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Setembro',
  case when month(sc.dt_saldo_conta) = 10 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Outubro',
  case when month(sc.dt_saldo_conta) = 11 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Novembro',
  case when month(sc.dt_saldo_conta) = 12 then sum(isnull(sc.vl_saldo_conta,0)) end as 'Dezembro',
  sum(isnull(sc.vl_saldo_conta,0)) as Total
into
  #SaldoMensal
from
  Saldo_Conta sc
where
  sc.dt_saldo_conta between @dt_inicial and @dt_final
group by
  sc.cd_conta,
  sc.dt_saldo_conta

--Mostra a Tabela com o Histórico

select
  gc.cd_grupo_conta,
  gc.nm_grupo_conta,
  pc.cd_mascara_conta,
  pc.nm_conta,
  pc.ic_conta_balanco,
  pc.qt_grau_conta,
  sm.*  
from
  Grupo_Conta gc, 
  Plano_Conta pc,
  #SaldoMensal sm
where
  isnull(gc.ic_balanco_grupo_conta,'N') = 'S' and
  gc.cd_grupo_conta = pc.cd_grupo_conta       and
  isnull(pc.ic_conta_balanco,'N')       = 'S' and
  pc.qt_grau_conta  <= @qt_grau_conta         and
  pc.cd_conta = sm.cd_conta
order by
  pc.cd_mascara_conta



