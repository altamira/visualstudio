
-------------------------------------------------------------------------------
--pr_deleta_usuario_banco_dados
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Deleta Todos os usuários de um banco de dados
--                  
--Data             : 11.12.2005
--Atualizado       : 11.12.2005
--
--------------------------------------------------------------------------------------------------
create procedure pr_deleta_usuario_banco_dados
@nm_banco varchar(15) = ''
as

declare @sql        varchar(8000)
declare @nm_usuario varchar(20)

if @nm_banco<>''
begin
  --set @sql = 'select name,* from '+@nm_banco+'.dbo.sysusers where issqluser=1 and name <> '+'''dbo'''

  --select name,* from egissql_fortaleza.dbo.sysusers where issqluser=1 and name <> 'dbo'

  select
    name as nm_usuario
  into #usuario
  from
    egissql_cydak.dbo.sysusers
   where issqluser=1 and name <> 'dbo'

  select * from #usuario

  while exists ( select top 1 nm_usuario from #usuario )
  begin
    select top 1
      @nm_usuario = nm_usuario
    from
      #Usuario

    EXEC sp_dropuser @nm_usuario

--    delete from sysusers where name=@nm_usuario
    delete from #usuario where nm_usuario=@nm_usuario

  end    

  --use @nm_banco
  --select name,* from @nm_banco+'.dbo.sysusers' where issqluser=1 and name <> 'dbo'
  --print @sql
  --exec(@sql)
  --EXEC sp_dropuser @nm_usuario

end

