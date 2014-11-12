
create procedure sp_DeletaIndice_atributo
@cd_tabela int output,
@cd_indice int output,
@cd_atributo int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Indice_atributo
     WHERE
         cd_tabela = @cd_tabela and 
         cd_indice = @cd_indice and 
         cd_atributo = @cd_atributo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

