
-------------------------------------------------------------------------------
--pr_acerto_documento_magnetico_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 21.072.006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_acerto_documento_magnetico_ativo
as

update
  documento_arquivo_magnetico
set
  ic_ativo_documento = 'S'
where
  ic_ativo_documento is null

