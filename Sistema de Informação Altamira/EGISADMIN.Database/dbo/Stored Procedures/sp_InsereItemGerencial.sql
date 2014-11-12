
CREATE procedure sp_InsereItemGerencial
@cd_item_gerencial int output,
@nm_item_gerencial varchar(20),
@cd_grupo_gerencial int,
@nu_ordem int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_item_gerencial = ISNULL(MAX(cd_item_gerencial),0) + 1 FROM Item_Gerencial TABLOCK
  INSERT INTO Item_Gerencial( cd_item_gerencial,
                              nm_item_gerencial,
                              cd_grupo_gerencial,
                              nu_ordem)
     VALUES (@cd_item_gerencial,
             @nm_item_gerencial,
             @cd_grupo_gerencial,
             @nu_ordem)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

