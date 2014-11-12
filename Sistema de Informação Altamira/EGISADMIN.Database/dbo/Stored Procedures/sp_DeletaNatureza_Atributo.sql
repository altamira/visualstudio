
CREATE procedure sp_DeletaNatureza_Atributo
@cd_natureza_atributo int output,
@nm_natureza_atributo varchar (30) output,
@cd_imagem int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Natureza_Atributo
     WHERE
         cd_natureza_atributo = @cd_natureza_atributo and 
         nm_natureza_atributo = @nm_natureza_atributo and 
         cd_imagem = @cd_imagem
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

