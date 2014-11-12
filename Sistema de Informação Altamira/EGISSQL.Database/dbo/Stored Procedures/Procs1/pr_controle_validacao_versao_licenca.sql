
-------------------------------------------------------------------------------
--sp_helptext pr_controle_validacao_versao_licenca
-------------------------------------------------------------------------------
--pr_controle_validacao_versao_licenca
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera a Tabela de Validação de Versão
--Data             : 13.08.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_controle_validacao_versao_licenca
@ic_parametro int = 0,
@cd_usuario   int = 0
as

select * from egis_versao

