
-------------------------------------------------------------------------------
--sp_helptext sp_gera_cadastro
-------------------------------------------------------------------------------
--sp_gera_cadastro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática de Cadastro
--Data             : 08.06.2007
--Alteração        : 18.06.2007 - Verificação se o Código existe no Cadastro
------------------------------------------------------------------------------
create procedure sp_gera_cadastro
@nm_banco_destino     varchar(25) = '',
@nm_tabela            varchar(50) = '',
@cd_chave             varchar(25) = '',
@cd_chave_comparativo varchar(25) = ''
as

--exec sp_gera_cadastro @nm_banco_destino,@tabela, @cd_produto,

declare @sql                   varchar(8000)
declare @sql_insert            varchar(8000)

--Inserção
set @sql_insert = 'insert into   '+@nm_banco_destino+'.dbo.'+@nm_tabela+' '+
                  'select * from '+@nm_tabela+' '+
                  'where '+@cd_chave+' = '+@cd_chave_comparativo


set @sql = 'if not exists (select top 1 '+@cd_chave+' from '+@nm_banco_destino+'.dbo.'+@nm_tabela+' '+' where '+@cd_chave+' = '+@cd_chave_comparativo+' ) '+
           ' begin '    +
           @sql_insert +   
           ' end '

-- print @sql_insert
-- select @sql_insert
--exec(@sql_insert)

--print @sql
--select @sql
exec(@sql)

