
CREATE procedure sp_InsereTipoMenu
@cd_tipo_menu int output,
@nm_tipo_menu varchar (40) output,
@sg_tipo_menu char (10) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_tipo_menu = ISNULL(MAX(cd_tipo_menu),0) + 1 FROM TipoMenu TABLOCK
  INSERT INTO TipoMenu( cd_tipo_menu,nm_tipo_menu,sg_tipo_menu)
     VALUES (@cd_tipo_menu,@nm_tipo_menu,@sg_tipo_menu)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

