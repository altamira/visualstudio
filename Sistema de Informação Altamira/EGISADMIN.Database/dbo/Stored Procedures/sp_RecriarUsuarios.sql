

CREATE PROCEDURE sp_RecriarUsuarios
AS
begin

declare @username char(15)
Declare cUsuario Cursor for
Select nm_fantasia_usuario from Usuario

open cUsuario

set nocount on
--Leitura
fetch next from cUsuario into @username
while @@fetch_status = 0
begin
 
  print 'Adicionando permissão para ' + @username + ' ...'
  
  /*Verifica se o usuário já não existe o login*/
  if not exists(Select 'x' from master.dbo.sysxlogins where name = @username)
     --Cria o login para o usuário
     EXEC SP_ADDLOGIN @username,'STANDARDPASSWORD','master','Português'

  /*Verifica se o usuário já não existe para o banco*/
  if not exists(Select 'x' from sysusers where name = @username)
     --Cria o usuário no banco
     EXEC SP_GRANTDBACCESS @username
  --Cria a permissão para o usuário 
  EXEC SP_ADDROLEMEMBER 'db_owner', @username

   fetch next from cUsuario into @username
end
set nocount off 
close cUsuario
deallocate cUsuario
end

