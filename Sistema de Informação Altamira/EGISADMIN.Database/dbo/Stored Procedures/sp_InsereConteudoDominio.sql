
CREATE PROCEDURE [sp_InsereConteudoDominio]
@cd_dominio int,
@cd_conteudo_dominio int output,
@nm_conteudo_dominio varchar(20)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_conteudo_dominio = ISNULL(MAX(cd_conteudo_dominio),0) + 1 
     FROM conteudo_dominio TABLOCK
     WHERE cd_dominio = @cd_dominio
  INSERT INTO Conteudo_dominio(cd_dominio,cd_conteudo_dominio,nm_conteudo_dominio)
     VALUES (@cd_dominio,@cd_conteudo_dominio,@nm_conteudo_dominio)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
  

