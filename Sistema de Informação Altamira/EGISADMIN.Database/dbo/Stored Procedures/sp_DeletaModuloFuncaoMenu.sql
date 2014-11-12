
CREATE procedure sp_DeletaModuloFuncaoMenu
@cd_modulo int,
@cd_funcao int,
@cd_menu int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  IF @cd_menu <> 0 
    DELETE FROM Modulo_Funcao_Menu
       WHERE cd_modulo = @cd_modulo
         AND cd_funcao = @cd_funcao
         AND cd_menu   = @cd_menu
  ELSE
    DELETE FROM Modulo_Funcao_Menu
       WHERE cd_modulo = @cd_modulo
         AND cd_funcao = @cd_funcao
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

