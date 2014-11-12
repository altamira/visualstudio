
-----------------------------------------------------------------------------------
--pr_consulta_movimento_conta
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta de Movimento Contábil por Conta
--                
--Data             : 27.12.2004
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------
create procedure pr_consulta_movimento_conta
@cd_conta   int,
@dt_inicial datetime,
@dt_final   datetime

as

select
  pc.cd_conta,
  pc.cd_conta_reduzido,
  pc.cd_mascara_conta,
  pc.nm_conta,

  --Saldo de Implantação
  sci.vl_saldo_implantacao,
  sci.ic_saldo_implantacao,

  --Saldo Inicial
  pc.vl_saldo_inicial_conta,
  pc.ic_saldo_inicial_conta,

  --Total Débito
  pc.vl_debito_conta,
  pc.vl_credito_conta,
 
  --Quantidade de Lançamentos

  pc.qt_lancamento_conta,

  --Total do Movimento

   pc.vl_debito_conta - pc.vl_credito_conta as 'TotalMovimento',

  --Saldo Atual

  pc.vl_saldo_atual_conta,
  pc.ic_saldo_atual_conta


from
  Plano_Conta pc,
  Saldo_Conta sc,
  Saldo_Conta_Implantacao sci
where
  @cd_conta   = pc.cd_conta   and
  pc.cd_conta *= sc.cd_conta  and
  pc.cd_conta *= sci.cd_conta and
  sci.dt_implantacao between @dt_inicial and @dt_final 


--select * from saldo_conta
--select * from plano_conta
--select * from movimento_contabil
--select * from saldo_conta_implantacao

