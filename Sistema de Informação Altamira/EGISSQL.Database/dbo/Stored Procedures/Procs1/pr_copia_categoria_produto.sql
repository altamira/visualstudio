
create procedure pr_copia_categoria_produto
@cd_categoria_produto_old int,
@nm_categoria_produto_new Varchar(40),
@cd_usuario int
as

Declare @cd_categoria_produto_new int
Declare @Tabela       varchar(50)  

----------------------------------------------------------------------------------------
--COPIA Maquina
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction

set @Tabela =  DB_NAME()+'.dbo.Categoria_Produto' 
-- campo chave utilizando a tabela de códigos  
exec EgisAdmin.dbo.sp_PegaCodigo @Tabela, 'cd_categoria_produto', @codigo = @cd_categoria_produto_new output  
print 'Codigo'

Select 
	 * 
into 
	#Categoria_Produto
from 
	Categoria_Produto
where 
	cd_categoria_produto = @cd_categoria_produto_old

Update #Categoria_Produto Set 
	cd_categoria_produto	= @cd_categoria_produto_new,
	cd_mascara_categoria = @nm_categoria_produto_new,
   cd_usuario 				= @cd_usuario,
   dt_usuario 				= GetDate()

insert into 
	Categoria_Produto
Select 
	* 
from 
	#Categoria_Produto



----------------------------------------------------------------------------------------
--COPIA As tabelas de Maquina
----------------------------------------------------------------------------------------
Print 'Complementos'
  -- Maquina_Ferramenta
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_categoria_produto', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Categoria_Produto_Idioma', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_categoria_produto_old,
  @cd_campo_chave_new = @cd_categoria_produto_new,
  @cd_usuario = @cd_usuario,
  @ic_so_considerar_principal = 'S'          
  print('Copiou '+ 'Categoria_Produto_Idioma')


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
		set @msn = 'Código da Nova Categoria Produto: ' +  cast(@cd_categoria_produto_new as char(8))
		
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		set @msn = 'Ocorreu um erro interno do Banco ao Cópiar  Categoria Produto!'
		print 'ERROR'
  end
 RAISERROR (@msn, 16, 1)

