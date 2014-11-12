
CREATE procedure sp_DeletaTipoMenu
@cd_tipo_menu int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM TipoMenu
     WHERE
         cd_tipo_menu = @cd_tipo_menu
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

