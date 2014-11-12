
create procedure pr_copia_maquina
@cd_maquina_old int,
@nm_maquina_new Varchar(40),
@cd_usuario int
as

Declare @cd_maquina_new int
Declare @Tabela       varchar(50)  

----------------------------------------------------------------------------------------
--COPIA Maquina
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction

set @Tabela =  DB_NAME()+'.dbo.Maquina' 
-- campo chave utilizando a tabela de códigos  
exec EgisAdmin.dbo.sp_PegaCodigo @Tabela, 'cd_maquina', @codigo = @cd_maquina_new output  
print 'Codigo'

Select 
	 * 
into 
	#Maquina 
from 
	Maquina
where 
	cd_maquina = @cd_maquina_old

Update #Maquina Set 
	cd_maquina          	= @cd_maquina_new,
	nm_maquina 				= @nm_maquina_new,
	nm_fantasia_maquina 	= @nm_maquina_new,
   cd_usuario = @cd_usuario,
   dt_usuario = GetDate()

insert into 
	Maquina
Select 
	* 
from 
	#Maquina



----------------------------------------------------------------------------------------
--COPIA As tabelas de Maquina
----------------------------------------------------------------------------------------
Print 'Complementos'

  -- Maquina_Ferramenta
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_maquina', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Maquina_Ferramenta', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_maquina_old,
  @cd_campo_chave_new = @cd_maquina_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Maquina_Ferramenta')

  -- Maquina_Turno
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_maquina', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Maquina_Turno', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_maquina_old,
  @cd_campo_chave_new = @cd_maquina_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Maquina_Turno')

  -- Maquina_Agenda
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_maquina', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Maquina_Agenda', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_maquina_old,
  @cd_campo_chave_new = @cd_maquina_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Maquina_Agenda')

  -- Maquina_Complemento
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_maquina', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Maquina_Complemento', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_maquina_old,
  @cd_campo_chave_new = @cd_maquina_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Maquina_Complemento')

  -- Maquina_Operacao
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_maquina', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Maquina_Operacao', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_maquina_old,
  @cd_campo_chave_new = @cd_maquina_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Maquina_Operacao')

  if @@ERROR <> 0
    return  

  print('Copiou EGISSQL!')

------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------
  Declare @msn as varchar(300)	
  if @@error = 0
  begin
    	commit transaction
		set @msn = 'Código da Nova Maquina: ' +  cast(@cd_maquina_new as char(8))
		
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		set @msn = 'Ocorreu um erro interno do Banco ao Cópiar Maquina!'
		print 'ERROR'
  end
 RAISERROR (@msn, 16, 1)

