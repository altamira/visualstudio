
-------------------------------------------------------------------------------
--pr_shrink_database
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_shrink_database
@nm_banco as varchar(100)
as
	if isnull(@nm_banco, '') <> ''
   begin
		exec('backup log '+@nm_banco+' with truncate_only')
		exec('dbcc shrinkdatabase(N'''+@nm_banco+''', truncateonly)')
	end
