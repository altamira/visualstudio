
create procedure pr_copia_ra
@cd_registro_atividade_old int,
@nm_ra_new Varchar(40),
@cd_usuario_emp int

as

Declare @cd_registro_atividade_new int
Declare @Tabela       varchar(50)  
Declare @SQL_PROC     varchar(5000)

----------------------------------------------------------------------------------------
--COPIA EMPRESA
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction

set @Tabela = db_name() + '.dbo.Registro_Atividade_Cliente' 
-- campo chave utilizando a tabela de códigos  
exec EGISADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_registro_atividade', @codigo = @cd_registro_atividade_new output  

Select 
	 * 
into 
	#RA 
from 
	Registro_Atividade_Cliente
where 
	cd_registro_atividade = @cd_registro_atividade_old

Update #RA Set 
	cd_registro_atividade	= @cd_registro_atividade_new,
	nm_ra 				        = @nm_ra_new + Cast( @cd_registro_atividade_new as varchar ),
	dt_registro_atividade = CONVERT(char(12), GETDATE(), 3),
	dt_inicio_atividade   = CONVERT(char(12), GETDATE(), 3),
	dt_final_atividade    = CONVERT(char(12), GETDATE(), 3),
  cd_usuario            = @cd_usuario_emp,
  dt_usuario            = CONVERT(char(12), GETDATE(), 3)
insert into 
	Registro_Atividade_Cliente
Select 
	* 
from 
	#RA

------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------
  if @@error = 0
  begin
   	commit transaction
		Select  'Código da Nova RA: ' +  cast(@cd_registro_atividade_new as char(8))  as Retorno 
    print 'OK'
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_registro_atividade_new, 'D'
  end
  else
  begin
  	rollback transaction   
		Select  'Ocorreu um erro interno do Banco ao Cópiar RA!' as Retorno
		print 'ERROR'
  end

