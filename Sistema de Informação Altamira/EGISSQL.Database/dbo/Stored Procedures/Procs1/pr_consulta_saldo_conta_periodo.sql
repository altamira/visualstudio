
-----------------------------------------------------------------------------------
--pr_consulta_saldo_conta_periodo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta de Saldo da Conta do Período
--                
--Data             : 27.12.2004
--Atualizado       : 28.12.2004
--                 : 
-----------------------------------------------------------------------------------
create procedure pr_consulta_saldo_conta_periodo
@dt_inicial datetime,
@dt_final   datetime
as

select
  pc.cd_conta,
  pc.cd_mascara_conta,
  pc.nm_conta,
  sc.dt_saldo_conta,
  sc.ic_inicial_saldo_conta,
  sc.vl_inicial_saldo_conta,
  sc.vl_debito_saldo_conta,
  sc.vl_credito_saldo_conta,
  sc.vl_saldo_conta,
  sc.ic_saldo_conta
from
  Plano_Conta pc,
  Saldo_Conta sc
where
  pc.cd_conta = sc.cd_conta


--select * from saldo_conta
--select * from plano_conta
--select * from movimento_contabil
