
create procedure sp_InserePais
@cd_pais int output,
@nm_pais varchar (20) output,
@sg_pais char (3) output,
@cd_ddi_pais char (2) output,
@cd_usuario int output,
@dt_usuario datetime output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_pais = ISNULL(MAX(cd_pais),0) + 1 FROM Pais TABLOCK
  INSERT INTO Pais( cd_pais,nm_pais,sg_pais,cd_ddi_pais,cd_usuario,dt_usuario)
     VALUES (@cd_pais,@nm_pais,@sg_pais,@cd_ddi_pais,@cd_usuario,@dt_usuario)
  Select 
         @cd_pais = cd_pais,
         @nm_pais = nm_pais,
         @sg_pais = sg_pais,
         @cd_ddi_pais = cd_ddi_pais,
         @cd_usuario = cd_usuario,
         @dt_usuario = dt_usuario
  From Pais
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

