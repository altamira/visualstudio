
-----------------------------------------------------------------------------------
--pr_consulta_movimento_contabil_conta
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
create procedure pr_consulta_movimento_contabil_conta
@dt_inicial datetime,
@dt_final   datetime
as

select
  pc.cd_conta,
  pc.cd_mascara_conta,
  pc.nm_conta
from
  Plano_Conta pc,
  Saldo_Conta sc
where
  pc.cd_conta = sc.cd_conta


--select * from saldo_conta
--select * from plano_conta
--select * from movimento_contabil
