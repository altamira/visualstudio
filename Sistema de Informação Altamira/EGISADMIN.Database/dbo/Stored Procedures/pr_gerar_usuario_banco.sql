



CREATE  PROCEDURE pr_gerar_usuario_banco
AS
begin

declare @username char(15)
declare @nm_banco_SQL char(50)

Declare cUsuario Cursor for
Select rtrim(nm_fantasia_usuario) from Usuario

open cUsuario

set nocount on

  create table #Usuario_Gerado
  (nm_fantasia_usuario char(15))


--Leitura
fetch next from cUsuario into @username
while @@fetch_status = 0
begin
  
  /*Verifica se o usuário já não existe o login*/
  if not exists(Select 'x' from master.dbo.sysxlogins where name = @username)
  begin
     --Cria o login para o usuário
     EXEC SP_ADDLOGIN @username,'STANDARDPASSWORD','master','Português'
     
     Insert into #Usuario_Gerado (nm_fantasia_usuario) values(@username)
  end

  /*Verifica se o usuário já não existe para o banco*/
  if not exists(Select 'x' from sysusers where name = @username)
     --Cria o usuário no banco
     EXEC SP_GRANTDBACCESS @username
  --Cria a permissão para o usuário 
  EXEC SP_ADDROLEMEMBER 'db_owner', @username
   Select @nm_banco_SQL = nm_banco_empresa from Empresa where cd_empresa = 1
   exec ('exec '+ @nm_banco_SQL +'.dbo.pr_gera_usuario_banco ' + @username)
  
   fetch next from cUsuario into @username
end
set nocount off 
close cUsuario
deallocate cUsuario

Select nm_fantasia_usuario from #Usuario_Gerado  order by nm_fantasia_usuario
drop table #Usuario_Gerado
end





