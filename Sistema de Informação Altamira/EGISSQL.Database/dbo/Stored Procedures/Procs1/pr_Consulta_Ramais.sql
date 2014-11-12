
-------------------------------------------------------------------------------
--pr_Consulta_Ramais
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Ramais de Telefones dos Usuários da Empresa
--Data             : 03/02/2004
--Alteração        : 09/12/2004 - Acerto da Cabeçalho da Stored Procedure
------------------------------------------------------------------------------
CREATE PROCEDURE pr_Consulta_Ramais
(
@nm_usuario varchar(40),
@nm_database varchar(40)
)
AS

declare @SQL varchar(8000)

set @SQL = 'Select 
              u.nm_usuario, 
              d.nm_departamento, 
              u.nm_ramal_usuario,
              u.nm_email_usuario, 
              u.cd_celular_usuario, 
              case (Select top 1 IsNull(cd_modulo,0) from Usuario_Log where cd_usuario = u.cd_usuario)
              when 0 then ''N''
              else ''S''
              end as Ativo  
            from 
              usuario u
            left outer join '+ @nm_database + '.dbo.departamento d
              on u.cd_departamento = d.cd_departamento 
            where u.ic_ativo <> ''I'''

if @nm_usuario <> ''
   set @SQL = @SQL + ' and nm_usuario like ''' +  @nm_usuario + '%'''
set @SQL = @SQL + ' order by d.nm_departamento'

exec (@SQL)

------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------
--exec pr_Consulta_Ramais
------------------------------------------------------------------------------
