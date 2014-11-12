
CREATE procedure sp_InsereNatureza_Atributo
@cd_natureza_atributo int output,
@nm_natureza_atributo varchar (30) output,
@cd_imagem int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_natureza_atributo = ISNULL(MAX(cd_natureza_atributo),0) + 1 FROM Natureza_Atributo TABLOCK
  INSERT INTO Natureza_Atributo( cd_natureza_atributo,nm_natureza_atributo,cd_imagem)
     VALUES (@cd_natureza_atributo,@nm_natureza_atributo,@cd_imagem)
  Select 
         @cd_natureza_atributo = cd_natureza_atributo,
         @nm_natureza_atributo = nm_natureza_atributo,
         @cd_imagem = cd_imagem
  From Natureza_Atributo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

