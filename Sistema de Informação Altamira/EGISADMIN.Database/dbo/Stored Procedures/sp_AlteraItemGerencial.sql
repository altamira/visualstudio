
CREATE procedure sp_AlteraItemGerencial
--dados depois da execuçao (novos)
@nm_item_gerencial varchar (20),
@cd_grupo_gerencial int,
@nu_ordem int,
--dados antes da execuçao (antigos)
@cd_item_gerencial_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Item_Gerencial SET
         nm_item_gerencial  = @nm_item_gerencial,
         cd_grupo_gerencial = @cd_grupo_gerencial,
         nu_ordem           = @nu_ordem 
     WHERE
         cd_item_gerencial  = @cd_item_gerencial_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

