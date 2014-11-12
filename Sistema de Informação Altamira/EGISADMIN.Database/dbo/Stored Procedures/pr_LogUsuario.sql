

CREATE PROCEDURE pr_LogUsuario
@cd_usuario_log int output,
@cd_empresa int,
@cd_usuario int,
@nm_modulo varchar(40),
@cd_funcao int,
@cd_menu int,
@nm_estacao varchar(40)
AS BEGIN

  declare @cd_modulo int
  declare @nConecao int /*Define o número de conexões abertas se 
			for mais de uma existe mais de um usuário 
			utilizando o sistema por isso o log não poderá
			ser atualizado*/
  
  SELECT @nConecao = count(loginame) FROM master.dbo.sysprocesses
         where upper(db_name(dbid)) = 'EGISSQL'

  /*Verifica se existe alguém logado caso não limpa o log da tabela*/
  if (@nConecao <= 1)
     truncate table Usuario_Log
  else
    /*Exclui o processo anterior*/
    delete from Usuario_Log where cd_usuario_log = @cd_usuario_log


  if @nm_modulo != '' begin
	/*Define o módulo caso esse tenha sido informado*/
	set @cd_modulo = 0
	Select @cd_modulo = cd_modulo from Modulo where nm_modulo = @nm_modulo
		
	/*Gera o novo processo*/  
	Insert into Usuario_Log
		(
		cd_empresa, 
		cd_usuario, 
		cd_modulo,
		cd_funcao,
		cd_menu,
                nm_estacao,
		dt_usuario
		) 
	Values
		(
		@cd_empresa, 
		@cd_usuario, 
		@cd_modulo,
		@cd_funcao,
		@cd_menu,
 		@nm_estacao,
		Getdate()
		)
	/*Pega o valor do processo gerado*/
	set @cd_usuario_log = @@identity      
    end
END

