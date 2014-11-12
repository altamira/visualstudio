
-------------------------------------------------------------------------------
--sp_helptext pr_zera_movimento_caixa
-------------------------------------------------------------------------------
--pr_zera_movimento_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zera Movimento Caixa
--Data             : 17.06.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_zera_movimento_caixa
as

--select * from conta_banco_saldo
--select * from conta_banco_lancamento

truncate table caixa_saldo
truncate table caixa_lancamento


