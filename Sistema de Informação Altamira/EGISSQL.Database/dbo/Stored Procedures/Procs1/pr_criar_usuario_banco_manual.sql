
-------------------------------------------------------------------------------
--sp_helptext pr_criar_usuario_banco_manual
-------------------------------------------------------------------------------
--pr_criar_usuario_banco_manual
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Gera usuários banco de forma manual 
--Data             : 11.05.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_criar_usuario_banco_manual
as

--------------------------------------------------------------------------------------------------
--select * from egisadmin.dbo.usuario
--------------------------------------------------------------------------------------------------
--Carlos Cardoso Fernandes
--Criação de usuários no Banco de Dados
--08.05.2008
--------------------------------------------------------------------------------------------------

declare @nm_fantasia_usuario varchar(15)
declare @cd_usuario          int

select 
  cd_usuario,
  nm_fantasia_usuario
into
  #usuario 
from egisadmin.dbo.usuario
while exists ( select top 1 cd_usuario from #Usuario)
begin
  select top 1
    @cd_usuario = cd_usuario,
    @nm_fantasia_usuario = nm_fantasia_usuario
  from
    #Usuario
  exec pr_gera_usuario_banco @nm_fantasia_usuario
  delete from #Usuario where cd_usuario=@cd_usuario
end
drop table #Usuario

