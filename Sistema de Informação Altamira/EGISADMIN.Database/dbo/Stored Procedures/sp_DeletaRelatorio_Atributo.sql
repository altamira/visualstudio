
create procedure sp_DeletaRelatorio_Atributo
@cd_relatorio int output,
@cd_tabela int output,
@cd_atributo int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Relatorio_Atributo
     WHERE
         cd_relatorio = @cd_relatorio and 
         cd_tabela = @cd_tabela and 
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

