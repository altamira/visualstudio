
-------------------------------------------------------------------------------
--pr_eliminacao_banco_dados
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : 
--Data             : 14.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_eliminacao_banco_dados
@nm_banco_dados varchar(25) = ''
as

declare @sql varchar(8000)

set @sql = ''
if @nm_banco_dados<>''
begin
  set @sql = 'drop database ['+@nm_banco_dados+']'
  print @sql
  exec (@sql)
end

