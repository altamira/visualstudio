
-------------------------------------------------------------------------------
--sp_helptext pr_limpeza_validacao_nfe
-------------------------------------------------------------------------------
--pr_limpeza_validacao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Limpeza de uma Tabela 
--Data             : 16.09.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_limpeza_validacao_nfe
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

delete from NFE_Validacao 


