
-------------------------------------------------------------------------------
--sp_helptext pr_apropriacao_movimento_financeiro
-------------------------------------------------------------------------------
--pr_apropriacao_movimento_financeiro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : EgisAdmin ou Egissql
--
--Objetivo         : 
--Data             : 01.01.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_apropriacao_movimento_financeiro
@dt_inicial datetime,
@dt_final   datetime
as

--Plano_Financeiro

select
  pf.cd_plano_financeiro,
  
  pf.nm_conta_plano_financeiro,
  pf.cd_mascara_plano_financeiro

from
  Plano_Financeiro pf

order by 
  pf.cd_mascara_plano_financeiro

