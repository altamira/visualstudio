

/****** Object:  Stored Procedure dbo.pr_LogUsuario    Script Date: 13/12/2002 15:08:10 ******/

CREATE PROCEDURE pr_LogUsuario
@cd_empresa int,
@cd_usuario int,
@nm_modulo varchar(40),
@cd_funcao int,
@cd_menu int
AS BEGIN

  declare @cd_modulo int
  /*Define o módulo */
  set @cd_modulo = 0
  Select @cd_modulo = cd_modulo from Modulo where nm_modulo = @nm_modulo

   /*Verifica se já existe um log para o usuário e o atualiza*/
   if exists(Select 'x' from Usuario_log where cd_empresa = @cd_empresa and cd_usuario = @cd_usuario)
      Update Usuario_Log Set
      cd_modulo  = @cd_modulo,
      cd_funcao  = @cd_funcao,
      cd_menu    = @cd_menu,
      dt_usuario = getdate()
      where cd_empresa = @cd_empresa and cd_usuario = @cd_usuario
   else
      Insert into Usuario_Log
      (
       cd_empresa, 
       cd_usuario, 
       cd_modulo,
       cd_funcao,
       cd_menu,
       dt_usuario
       ) 
       Values
      (
       @cd_empresa, 
       @cd_usuario, 
       @cd_modulo,
       @cd_funcao,
       @cd_menu,
       getdate()
       )
      
END



