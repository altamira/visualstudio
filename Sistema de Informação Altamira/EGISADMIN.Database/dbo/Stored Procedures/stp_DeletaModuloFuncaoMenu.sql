
CREATE PROCEDURE [stp_DeletaModuloFuncaoMenu]
@cd_modulo int,
@cd_funcao int,
@cd_menu int
 AS
  if @cd_menu is null 
     delete from Modulo_funcao_menu
           where cd_modulo = @cd_modulo 
             and cd_funcao = @cd_funcao
  else
     delete from Modulo_funcao_menu
           where cd_modulo = @cd_modulo 
             and cd_funcao = @cd_funcao
             and cd_menu   = @cd_menu
     

