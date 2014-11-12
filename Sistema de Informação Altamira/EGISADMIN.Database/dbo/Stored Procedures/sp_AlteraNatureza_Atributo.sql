
CREATE procedure sp_AlteraNatureza_Atributo
--dados depois da execuçao (novos)
@cd_natureza_atributo int ,
@nm_natureza_atributo varchar (30),
@cd_imagem int ,
--dados antes da execuçao (antigos)
@cd_natureza_atributo_old int ,
@nm_natureza_atributo_old varchar (30),
@cd_imagem_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Natureza_Atributo SET
         cd_natureza_atributo = @cd_natureza_atributo,
         nm_natureza_atributo = @nm_natureza_atributo,
         cd_imagem = @cd_imagem
     WHERE
         cd_natureza_atributo = @cd_natureza_atributo_old and 
         nm_natureza_atributo = @nm_natureza_atributo_old and 
         cd_imagem = @cd_imagem_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

