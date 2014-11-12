
-------------------------------------------------------------------------------
--pr_deleta_documento_magnetico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 12.01.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_deleta_documento_magnetico
@cd_documento_magnetico int = 0
as
	Begin Transaction
--*****************************************************************************
      Print 'Sequencia_Arquivo_Magnetico'
		Delete 
		from 	Sequencia_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Atualizacao_Arquivo_Magnetico'	
		Delete 
		from 	Atualizacao_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Parametro_Arquivo_Magnetico'	
		Delete 
		from 	Parametro_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Log_Arquivo_Magnetico'	
		Delete 
		from 	Log_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Filtro_Arquivo_Magnetico'	
		Delete 
		from 	Filtro_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Arquivo_Magnetico'	
		Delete 
		from 	Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Campo_Arquivo_Magnetico'	
		Delete 
		from 	Campo_Arquivo_Magnetico
		where cd_sessao_documento in (Select cd_sessao_arquivo_magneti 
												From  Sessao_Arquivo_Magnetico 
												where cd_documento_magnetico =  @cd_documento_magnetico)

--*****************************************************************************
		Print 'Sessao_Arquivo_Magnetico'	
		Delete 
		from 	Sessao_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
		Print 'Documento_Magnetico'	
		Delete 
		from 	Documento_Arquivo_Magnetico
		where cd_documento_magnetico = @cd_documento_magnetico
--*****************************************************************************
   declare @msn varchar(150)
  	if @@error = 0  
  	begin  
			commit transaction  
  	  		set @msn = 'Documento Deletado com exito!'      
    		print 'OK'  
  	end  
  	else  
  	begin  
     		rollback transaction     
  			set @msn = 'Ocorreu um erro interno do Banco ao Deletar o Documento Magnético!'  
  			print 'ERROR'  
  	end  
 	RAISERROR (@msn, 16, 1)  	  
