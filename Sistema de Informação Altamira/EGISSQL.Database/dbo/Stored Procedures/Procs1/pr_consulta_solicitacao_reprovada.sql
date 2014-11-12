
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_solicitacao_reprovada
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Solicitações Reprovadas
--Data             : 26.11.2007
--Alteração        : 18.02.2008 - Acerto da Procedure
------------------------------------------------------------------------------
create procedure pr_consulta_solicitacao_reprovada
@dt_inicial datetime = '',
@dt_final   datetime = ''
as



