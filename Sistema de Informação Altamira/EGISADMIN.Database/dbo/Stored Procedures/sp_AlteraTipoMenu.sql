
CREATE procedure sp_AlteraTipoMenu
--dados depois da execuçao (novos)
@cd_tipo_menu int,
@nm_tipo_menu varchar (40),
@sg_tipo_menu char (10),
--dados antes da execuçao (antigos)
@cd_tipo_menu_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE TipoMenu SET
         cd_tipo_menu = @cd_tipo_menu,
         nm_tipo_menu = @nm_tipo_menu,
         sg_tipo_menu = @sg_tipo_menu
     WHERE
         cd_tipo_menu = @cd_tipo_menu_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

