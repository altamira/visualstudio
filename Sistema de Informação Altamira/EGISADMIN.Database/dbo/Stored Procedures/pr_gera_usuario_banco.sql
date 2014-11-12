

CREATE PROCEDURE pr_gera_usuario_banco  
AS  
begin   

	declare @username         char(15)  
	declare @nm_banco_empresa char(25)  
  
	Declare cUsuario Cursor for  
	   Select rtrim(nm_fantasia_usuario) from Usuario  
  
	open cUsuario  
 
   	create table #Usuario_Gerado (nm_fantasia_usuario char(15))    
  
	--Leitura  
	fetch next from cUsuario into @username  
	while @@fetch_status = 0  
	begin  
	     /*Verifica se o usuário já não existe o login*/  
--  	     if not exists(Select 'x' from master.dbo.sysxlogins where name = @username)  
  	     if not exists(Select 'x' from sys.sql_logins where name = @username)  
  	     begin  
     	         --Cria o login para o usuário  
--                 EXEC SP_ADDLOGIN @username,'STANDARDPASSWORD','master','Português'  
                 Print '**LOGIN CRIADO NO BANCO MASTER : '   + @username  
                 Insert into #Usuario_Gerado (nm_fantasia_usuario) values(@username)  
        end  
  
  	    /*Verifica se o usuário já não existe para o banco*/  
       if not exists(Select 'x' from sysusers where name = @username)  
       begin   
     	 	--Cria o usuário no banco  
--     		EXEC SP_GRANTDBACCESS @username  
     		--Cria a permissão para o usuário   
--     		EXEC SP_ADDROLEMEMBER 'db_owner', @username  
  
     		Print '**LOGIN CRIADO NO EGISADMIN: '  
       end;  
  
      --Cria um Cursor com Todas as Empresa  

     declare CEmpresa Cursor for   
     select name from master.dbo.sysdatabases 
     where name in (select nm_banco_empresa from egisadmin.dbo.empresa)
  
 open CEmpresa  
  
 FETCH NEXT FROM CEmpresa INTO @nm_banco_empresa  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
     --Executa o Usuario de empresa em empresa  
--print @nm_banco_empresa

     exec ('exec '+ @nm_banco_empresa +'.dbo.pr_gera_usuario_banco ' + @username)  
  
   FETCH NEXT FROM CEmpresa INTO @nm_banco_empresa         

 END
   
 Close CEmpresa  
 DEALLOCATE CEmpresa  
    
   fetch next from cUsuario into @username  

end  
set nocount off   
close      cUsuario  
deallocate cUsuario  
  
Select nm_fantasia_usuario from #Usuario_Gerado  order by nm_fantasia_usuario  
drop table #Usuario_Gerado  

end  
  
  
