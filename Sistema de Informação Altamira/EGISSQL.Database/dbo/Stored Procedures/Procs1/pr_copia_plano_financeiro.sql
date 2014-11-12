
create procedure pr_copia_plano_financeiro
@cd_plano_financeiro_old int,
@nm_plano_financeiro_new Varchar(40),
@cd_usuario int
as

Declare @cd_plano_financeiro_new int
Declare @Tabela       varchar(50)  

----------------------------------------------------------------------------------------
--COPIA Maquina
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction

set @Tabela =  DB_NAME()+'.dbo.plano_financeiro' 
-- campo chave utilizando a tabela de códigos  
exec EgisAdmin.dbo.sp_PegaCodigo @Tabela, 'cd_plano_financeiro', @codigo = @cd_plano_financeiro_new output  
print 'Codigo'

Select 
	 * 
into 
	#plano_financeiro
from 
	plano_financeiro
where 
	cd_plano_financeiro = @cd_plano_financeiro_old

Update #plano_financeiro Set 
	cd_plano_financeiro	   		= @cd_plano_financeiro_new,
	cd_mascara_plano_financeiro 	= @nm_plano_financeiro_new,
   cd_usuario 						= @cd_usuario,
   dt_usuario 						= GetDate()

insert into 
	plano_financeiro
Select 
	* 
from 
	#plano_financeiro



----------------------------------------------------------------------------------------
--COPIA As tabelas de Maquina
----------------------------------------------------------------------------------------
Print 'Complementos'
/*
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_plano_financeiro', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'plano_financeiro_Orcamento', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_plano_financeiro_old,
  @cd_campo_chave_new = @cd_plano_financeiro_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'plano_financeiro_Orcamento') */


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
		set @msn = 'Código da Novo Plano financeiro: ' +  cast(@cd_plano_financeiro_new as char(8))
		
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		set @msn = 'Ocorreu um erro interno do Banco ao Cópiar Plano financeiro!'
		print 'ERROR'
  end
 RAISERROR (@msn, 16, 1)

