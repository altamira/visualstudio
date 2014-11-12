
-------------------------------------------------------------------------------
--pr_copia_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : EgisAdmin
--Objetivo         : Cópia do Usuario
--Data             : 14/08/2006
--Alteração        : 13.02.2009
-- 26.05.2009 - Verificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_copia_usuario
@cd_usuario_old   int,
@cd_usuario_copia int, -- Usuario que está fazendo a Cópia
@nm_usuario_new   Varchar(40)
as

Declare @cd_usuario_new int
Declare @Tabela         varchar(50)  
declare @dt_hoje        datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

if exists(Select top 1 * from Usuario with (nolock)
          where cd_usuario = @cd_usuario_old)
begin
----------------------------------------------------------------------------------------
--COPIA O USUARIO
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction
set @Tabela =  'Usuario' 

-- campo chave utilizando a tabela de códigos  
exec sp_PegaCodigo @Tabela, 'cd_usuario', @codigo = @cd_usuario_new output  

  while exists(Select top 1 'x' from usuario where cd_usuario = @cd_usuario_new)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_usuario', @codigo = @cd_usuario_new output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_usuario_new, 'D'
  end


Select 
  * 
into 
  #Usuario 
from 
  Usuario with (nolock)
where 
  cd_usuario = @cd_usuario_old

Update #Usuario Set 
	cd_usuario          	= @cd_usuario_new,
	nm_usuario 		= @nm_usuario_new,
        cd_senha_usuario        = 'gbs',
	nm_fantasia_usuario 	= @nm_usuario_new,
--	dt_cadastro_usuario     = dbo.fn_Data(GetDate()),
        dt_cadastro_usuario     = @dt_hoje,
	cd_usuario_atualiza     = @cd_usuario_copia

insert into 
	Usuario
Select 
	* 
from 
	#Usuario
where
  cd_usuario not in ( select cd_usuario 
                      from 
                        usuario with (nolock) )

----------------------------------------------------------------------------------------
--COPIA O Departamento_Usuario
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Departamento_Usuario
from 
	Departamento_Usuario
where 
	cd_usuario = @cd_usuario_old


Update #Departamento_Usuario 
Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
	--dt_atualiza		= dbo.fn_Data(GetDate())
        dt_atualiza             = @dt_hoje


delete from 
   Departamento_Usuario
where  
  cd_usuario = @cd_usuario_new

insert into 
	Departamento_Usuario
Select 
	* 
from 
	#Departamento_Usuario

----------------------------------------------------------------------------------------
--COPIA O Menu_Usuario
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Menu_Usuario
from 
	Menu_Usuario 
where 
	cd_usuario = @cd_usuario_old

Update #Menu_Usuario Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
	dt_atualiza		= dbo.fn_Data(GetDate())


delete Menu_Usuario
where  
  cd_usuario = @cd_usuario_new

insert into 
	Menu_Usuario
Select 
	* 
from 
	#Menu_Usuario


----------------------------------------------------------------------------------------
--COPIA O Usuario_Acesso_Automatico
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Acesso_Automatico
from 
	Usuario_Acesso_Automatico 
where 
	cd_usuario_acesso = @cd_usuario_old

Update #Usuario_Acesso_Automatico Set 
	cd_usuario_acesso   	= @cd_usuario_new,
	cd_usuario 				= @cd_usuario_copia, 
	dt_usuario 				= dbo.fn_Data(GetDate())


insert into 
	Usuario_Acesso_Automatico
Select 
	* 
from 
	#Usuario_Acesso_Automatico


----------------------------------------------------------------------------------------
--COPIA O Usuario_Assinatura
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Assinatura
from 
	Usuario_Assinatura 
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Assinatura Set 
	cd_usuario          	= @cd_usuario_new,
	--dt_usuario 				= dbo.fn_Data(GetDate())
        dt_usuario              = @dt_hoje


insert into 
	Usuario_Assinatura
Select 
	* 
from 
	#Usuario_Assinatura


----------------------------------------------------------------------------------------
--COPIA O Usuario_Classe_Tabsheet
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Classe_Tabsheet
from 
	Usuario_Classe_Tabsheet Usuario
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Classe_Tabsheet Set 
	cd_usuario          	= @cd_usuario_new,
	--dt_usuario 				= dbo.fn_Data(GetDate())
        dt_usuario = @dt_hoje


insert into 
	Usuario_Classe_Tabsheet
Select 
	* 
from 
	#Usuario_Classe_Tabsheet


----------------------------------------------------------------------------------------
--COPIA O Usuario_Config
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Config
from 
	Usuario_Config 
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Config Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
	dt_atualiza 			= dbo.fn_Data(GetDate()),
	dt_usuario				= dbo.fn_Data(GetDate())



insert into 
	Usuario_Config
Select 
	* 
from 
	#Usuario_Config

----------------------------------------------------------------------------------------
--COPIA O 
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Email
from 
	Usuario_Email
Usuario
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Email Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
-- 	dt_usuario 				= dbo.fn_Data(GetDate()),
-- 	dt_usuario_atualiza	= dbo.fn_Data(GetDate())
        dt_usuario              = @dt_hoje,
        dt_usuario_atualiza     = @dt_hoje
 

insert into 
	Usuario_Email
Select 
	* 
from 
	#Usuario_Email
----------------------------------------------------------------------------------------
--COPIA O 
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Empresa
from 
	Usuario_Empresa 
where 
	cd_usuario_empresa = @cd_usuario_old

Update #Usuario_Empresa Set 
	cd_usuario_empresa 	= @cd_usuario_new,
	cd_usuario 				= @cd_usuario_copia, 
	--dt_usuario 				= dbo.fn_Data(GetDate())
        dt_usuario = @dt_hoje


insert into 
	Usuario_Empresa
Select 
	* 
from 
	#Usuario_Empresa

----------------------------------------------------------------------------------------
--COPIA O 
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Internet
from 
	Usuario_Internet
where 
	cd_usuario_internet = @cd_usuario_old

Update #Usuario_Internet Set 
	cd_usuario_internet 	= @cd_usuario_new,
	cd_usuario 				= @cd_usuario_copia, 
--	dt_usuario				= dbo.fn_Data(GetDate())
        dt_usuario = @dt_hoje


insert into 
	Usuario_Internet 
Select 
	* 
from 
	#Usuario_Internet

----------------------------------------------------------------------------------------
--COPIA O 
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Info_Gerencial
from 
	Usuario_Info_Gerencial 
where 
	cd_usuario_info_gerencial = @cd_usuario_old

Update #Usuario_Info_Gerencial Set 
	cd_usuario_info_gerencial 	= @cd_usuario_new,
	cd_usuario 						= @cd_usuario_copia, 
--	dt_usuario 						= dbo.fn_Data(GetDate())
        dt_usuario = @dt_hoje


insert into 
	Usuario_Info_Gerencial
Select 
	* 
from 
	#Usuario_Info_Gerencial

----------------------------------------------------------------------------------------
--COPIA O Usuario_GrupoUsuario
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_GrupoUsuario
from 
	Usuario_GrupoUsuario 
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_GrupoUsuario Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
-- 	dt_atualiza 			= dbo.fn_Data(GetDate()),
-- 	dt_usuario 				= dbo.fn_Data(GetDate())
        dt_atualiza = @dt_hoje,
        dt_usuario  = @dt_hoje


insert into 
	Usuario_GrupoUsuario
Select 
	* 
from 
	#Usuario_GrupoUsuario

----------------------------------------------------------------------------------------
--COPIA O Usuario_Modulo
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Modulo
from 
	Usuario_Modulo 
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Modulo Set 
	cd_usuario          	= @cd_usuario_new,
	cd_usuario_atualiza 	= @cd_usuario_copia, 
-- 	dt_atualiza 			= dbo.fn_Data(GetDate()),
-- 	dt_usuario 				= dbo.fn_Data(GetDate())
        dt_atualiza = @dt_hoje,
        dt_usuario  = @dt_hoje



insert into 
	Usuario_Modulo
Select 
	* 
from 
	#Usuario_Modulo

----------------------------------------------------------------------------------------
--COPIA O Usuario_Modulo
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Usuario_Menu_Internet
from 
	Usuario_Menu_Internet 
where 
	cd_usuario = @cd_usuario_old

Update #Usuario_Menu_Internet Set 
	cd_usuario          	= @cd_usuario_new



insert into 
	Usuario_Menu_Internet
Select 
	* 
from 
	#Usuario_Menu_Internet

------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------
  if @@error = 0
  begin
    	commit transaction
		Select  'Código do Novo Usuário: ' +  cast(@cd_usuario_new as char(8)) + ', senha:  gbs' as Retorno
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		Select  'Ocorreu um erro interno do Banco ao Cópiar Usuário!' as Retorno
		print 'ERROR'
  end


------------------------------------------------------------------------------
--Cria Usuario Fisico
------------------------------------------------------------------------------
Print 'Cria Usuario Fisico'

if not exists(Select 'x' from master.dbo.sysxlogins where name = @nm_usuario_new)  
begin  
	--Cria o login para o usuário  
	EXEC SP_ADDLOGIN @nm_usuario_new,'STANDARDPASSWORD','master','Português'  
end  
  
/*Verifica se o usuário já não existe para o banco*/  
if not exists(Select 'x' from sysusers where name = @nm_usuario_new)  
begin   
		--Cria o usuário no banco  
		EXEC SP_GRANTDBACCESS @nm_usuario_new  
		--Cria a permissão para o usuário   
		EXEC SP_ADDROLEMEMBER 'db_owner', @nm_usuario_new 
end  



Create Table #Procedure(
	nm_procedure Varchar(100)
)

Declare @nm_banco_empresa char(25)  
declare CEmpresa Cursor for   
select name from master.dbo.sysdatabases 
where name in (select nm_banco_empresa 
               from egisadmin.dbo.empresa)
  
open CEmpresa  
  
FETCH NEXT FROM CEmpresa INTO @nm_banco_empresa  
WHILE @@FETCH_STATUS = 0  
BEGIN  
     --Executa o Usuario de empresa em empresa  
		print @nm_banco_empresa

		--Exec('insert into #procedure Select name from '+ @nm_banco_empresa +'.dbo.sysobjects	where name= ''pr_gera_usuario_banco'' and Xtype = ''P''')

  		if exists(Select * from #Procedure)			
     		exec ('exec '+ @nm_banco_empresa +'.dbo.pr_gera_usuario_banco ' + @nm_usuario_new)  

		Delete from #Procedure

     FETCH NEXT FROM CEmpresa INTO @nm_banco_empresa         
END  
   
Close CEmpresa  
DEALLOCATE CEmpresa  

Drop Table #Procedure
end
else
begin
  Select  'Código do Usuário: ' +  cast(@cd_usuario_old as char(8)) + ' Não Existe' as Retorno
end


