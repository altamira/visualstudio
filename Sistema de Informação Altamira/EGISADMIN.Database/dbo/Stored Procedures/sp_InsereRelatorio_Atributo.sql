
create procedure sp_InsereRelatorio_Atributo
@cd_relatorio int output,
@cd_tabela int output,
@cd_atributo int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  INSERT INTO Relatorio_Atributo( cd_relatorio,cd_tabela,cd_atributo)
     VALUES (@cd_relatorio,@cd_tabela,@cd_atributo)
  Select 
         @cd_relatorio = cd_relatorio,
         @cd_tabela = cd_tabela,
         @cd_atributo = cd_atributo
  From Relatorio_Atributo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

