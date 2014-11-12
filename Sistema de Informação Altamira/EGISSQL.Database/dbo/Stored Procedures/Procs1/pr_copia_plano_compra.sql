
create procedure pr_copia_plano_compra
@cd_plano_compra_old int,
@nm_plano_compra_new Varchar(40),
@cd_usuario int
as

Declare @cd_plano_compra_new int
Declare @Tabela       varchar(50)  

----------------------------------------------------------------------------------------
--COPIA Maquina
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction

set @Tabela =  DB_NAME()+'.dbo.plano_compra' 
-- campo chave utilizando a tabela de códigos  
exec EgisAdmin.dbo.sp_PegaCodigo @Tabela, 'cd_plano_compra', @codigo = @cd_plano_compra_new output  
print 'Codigo'

Select 
	 * 
into 
	#plano_compra
from 
	plano_compra
where 
	cd_plano_compra = @cd_plano_compra_old

Update #plano_compra Set 
	cd_plano_compra	   		= @cd_plano_compra_new,
	cd_mascara_plano_compra 	= @nm_plano_compra_new,
   cd_usuario 						= @cd_usuario,
   dt_usuario 						= GetDate()

insert into 
	plano_compra
Select 
	* 
from 
	#plano_compra



----------------------------------------------------------------------------------------
--COPIA As tabelas de Maquina
----------------------------------------------------------------------------------------
Print 'Complementos'
/*
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_plano_compra', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'plano_compra_Orcamento', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_plano_compra_old,
  @cd_campo_chave_new = @cd_plano_compra_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'plano_compra_Orcamento') */


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
		set @msn = 'Código da Novo Plano Compra: ' +  cast(@cd_plano_compra_new as char(8))
		
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		set @msn = 'Ocorreu um erro interno do Banco ao Cópiar Plano Compra!'
		print 'ERROR'
  end
 RAISERROR (@msn, 16, 1)

