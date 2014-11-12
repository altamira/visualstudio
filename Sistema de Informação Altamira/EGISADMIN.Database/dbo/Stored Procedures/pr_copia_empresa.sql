
create procedure pr_copia_empresa
@cd_empresa_old int,
@nm_banco varchar(50), -- Banco que o usuário escolheu para fazer a cópia
@nm_empresa_new Varchar(40),
@cd_usuario_emp int
as

Declare @cd_empresa_new int
Declare @Tabela       varchar(50)  
Declare @SQL_PROC     varchar(5000)

----------------------------------------------------------------------------------------
--COPIA EMPRESA
----------------------------------------------------------------------------------------
set @Tabela =  'Empresa' 
-- campo chave utilizando a tabela de códigos  
exec sp_PegaCodigo @Tabela, 'cd_empresa', @codigo = @cd_empresa_new output  

--Inicia Transação
Begin Transaction

Select 
	 * 
into 
	#Empresa 
from 
	Empresa
where 
	cd_empresa = @cd_empresa_old

Update #Empresa Set 
	cd_empresa          	= @cd_empresa_new,
	nm_empresa 				= @nm_empresa_new,
	nm_fantasia_empresa 	= @nm_empresa_new,
	dt_cadastro_empresa  = GetDate(),
--	dt_cadastro_empresa  = dbo.fn_Data(GetDate()),
        cd_usuario = @cd_usuario_emp,
        dt_usuario = GetDate()

insert into 
	Empresa
Select 
	* 
from 
	#Empresa

----------------------------------------------------------------------------------------
--COPIA As tabelas de Empresa que estão no EGISADMIN
----------------------------------------------------------------------------------------


  -- Empresa_Assinatura 
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_empresa', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Parametro_Empresa', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_empresa_old,
  @cd_campo_chave_new = @cd_empresa_new,
  @cd_usuario = @cd_usuario_emp,
  @ic_so_considerar_principal = 'S'

          
  print('Copiou '+ 'Parametro_Empresa')

  -- Empresa_Mensagem ( tabela fora de padrão ) 
  exec pr_copia_tabela_geral
  @nm_campo_chave  = 'cd_empresa_mensagem', -- Nome do campo chave da tabela a ser copiada
  @nm_tabela_copia  = 'Empresa_Mensagem', -- Nome da tabela a ser copiada
  @cd_campo_chave_old = @cd_empresa_old,
  @cd_campo_chave_new = @cd_empresa_new,
  @cd_usuario = @cd_usuario_emp,
  @ic_so_considerar_principal = 'S'

  print('Copiou '+ 'Empresa_Mensagem')



----------------------------------------------------------------------------------------
--COPIA as tabelas de empresa do Banco selecionado.
----------------------------------------------------------------------------------------


set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Assinatura', '''') + ', ' + -- Nome da tabela a ser copiada
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''')

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Assinatura', '''') )


set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Cotacao', '''') + ', ' +
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''') 

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Cotacao', '''') )

  if @@ERROR <> 0
    return  

set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Entrega', '''') + ', ' +
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''') 

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Entrega', '''') )

  if @@ERROR <> 0
    return  


set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Pedido', '''') + ', ' + -- Nome da tabela a ser copiada
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''')

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Pedido', '''') )

  if @@ERROR <> 0
    return  


set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Proposta', '''') + ', ' + -- Nome da tabela a ser copiada
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''') 

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Proposta', '''') )

  if @@ERROR <> 0
    return  


set @SQL_PROC = 
' exec ' + @nm_banco + '..pr_copia_tabela_geral ' +
                  ' @nm_campo_chave  = ' + Quotename('cd_empresa', '''') + ', ' + -- Nome do campo chave da tabela a ser copiada
                  ' @nm_tabela_copia  = ' + QuoteName(@nm_banco + '.dbo.Empresa_Requisicao', '''') + ', ' + -- Nome da tabela a ser copiada
                  ' @cd_campo_chave_old = ' + cast(@cd_empresa_old as varchar(3)) + ', ' +
                  ' @cd_campo_chave_new = ' + cast(@cd_empresa_new as varchar(3)) + ', ' +
                  ' @cd_usuario = ' + cast(@cd_usuario_emp as varchar(3))+ ', ' +
                  ' @ic_so_considerar_principal = ' + Quotename('S','''')

           

  print(@SQL_PROC)
  exec(@SQL_PROC)

 print('Copiou' + QuoteName('Empresa_Requisicao', '''') )

  if @@ERROR <> 0
    return  

  print('Copiou EGISSQL!')

------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------

  if @@error = 0
  begin
    	commit transaction
		Select  'Código da Nova Empresa: ' +  cast(@cd_empresa_new as char(8))  as Retorno 
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		Select  'Ocorreu um erro interno do Banco ao Cópiar Empresa!' as Retorno
		print 'ERROR'
  end


