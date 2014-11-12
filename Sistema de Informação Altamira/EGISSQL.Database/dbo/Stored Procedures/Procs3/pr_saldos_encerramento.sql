
-----------------------------------------------------------------------------------
--pr_saldos_encerramento
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta de Saldos de Encerramento
--                
--Data             : 28.12.2004
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------

create procedure pr_saldos_encerramento
@cd_conta   int,
@dt_inicial datetime,
@dt_final   datetime

as


select
  gc.nm_grupo_conta,
  pc.cd_conta,
  pc.cd_conta_reduzido,
  pc.cd_mascara_conta,
  pc.nm_conta,
  sc.dt_saldo_conta,
  sc.vl_saldo_conta,
  sc.ic_saldo_conta,
  sc.cd_usuario,
  u.nm_fantasia_usuario

from
  Plano_Conta pc 
  left outer join Grupo_Conta gc            on pc.cd_grupo_conta = gc.cd_grupo_conta 
  left outer join Saldo_Conta sc            on pc.cd_conta       = sc.cd_conta
  left outer join egisadmin.dbo.usuario u   on sc.cd_usuario     = u.cd_usuario

where
  pc.cd_conta = case when @cd_conta>0 then @cd_conta else pc.cd_conta end and
  sc.dt_saldo_conta between @dt_inicial and @dt_final  


--select * from saldo_conta
--select * from plano_conta
--select * from movimento_contabil
--select * from saldo_conta_implantacao

