
CREATE procedure sp_DeletaImagem
@cd_imagem int output
/*
,
@nm_imagem varchar (30) output,
@sg_imagem char (10) output,
@nm_arquivo_imagem varchar (50) output,
@nm_local_imagem varchar (50) output
*/
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Imagem
     WHERE
         cd_imagem = @cd_imagem
/* and 
         nm_imagem = @nm_imagem and 
         sg_imagem = @sg_imagem and 
         nm_arquivo_imagem = @nm_arquivo_imagem and 
         nm_local_imagem = @nm_local_imagem
*/
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

