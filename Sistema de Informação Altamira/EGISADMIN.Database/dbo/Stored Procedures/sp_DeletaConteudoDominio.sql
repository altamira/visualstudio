
create procedure sp_DeletaConteudoDominio
--dados antes da execuçao (antigos)
@cd_dominio_old int,
@cd_conteudo_dominio_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  DELETE FROM Conteudo_Dominio
     WHERE
         cd_dominio = @cd_dominio_old and 
         cd_conteudo_dominio = @cd_conteudo_dominio_old 
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

