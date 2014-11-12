
-------------------------------------------------------------------------------
--pr_restauracao_banco_dados
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Restauração do Banco de Dados no SQL
--Data             : 14.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_restauracao_banco_dados
@nm_banco_dados   varchar(25)  = '',
@nm_caminho       varchar(100) = '',
@nm_banco_backup  varchar(100) = ''

as

declare @nm_banco_completo varchar(100)   --Nome do Banco   de Dados      
declare @nm_log_completo   varchar(100)   --Nome do Arquivo de Log

declare @nm_banco          varchar(100)   --Nome do Banco   de Dados      
declare @nm_log            varchar(100)   --Nome do Arquivo de Log

declare @sql               varchar(8000)  --Comando SQL

set @nm_banco          = +@nm_banco_dados+'_Data'
set @nm_log            = +@nm_banco_dados+'_Log'

set @nm_banco_completo = @nm_caminho+'\'+@nm_banco_dados+'_Data.MDF'
set @nm_log_completo   = @nm_caminho+'\'+@nm_banco_dados+'_Log.MDF'

set @sql = ''

if @nm_banco_dados<>''
begin

--  RESTORE DATABASE [ccf] 
-- FROM  
--   DISK = N'D:\BkpSQL\EgisAdmin_db_200607121500.BAK' 
--   WITH  FILE = 1,  NOUNLOAD ,  STATS = 10,  RECOVERY ,  REPLACE ,  
--   MOVE N'EgisAdmin_Data' TO N'D:\bdsql\EgisAdmin_Data.MDF',  
--   MOVE N'EgisAdmin_Log'  TO N'D:\bdsql\EgisAdmin_log.LDF'

  set @sql = 'RESTORE DATABASE ['+@nm_banco_dados+'] '+
             'FROM DISK = N'''+@nm_banco_backup+''''+' '+
             'WITH  FILE = 1,  NOUNLOAD ,  STATS = 10,  RECOVERY ,  REPLACE ,  '+
             'MOVE N'''+@nm_banco+''''+' TO N'''+@nm_banco_completo+''''+',  '+
             'MOVE N'''+@nm_log+''''+' TO N'''+@nm_log_completo+''''


  print @sql
 
  --exec (@sql)

end

--Criação do Banco de Dados

