
create procedure sp_AlteraRelatorio_Atributo
--dados depois da execuçao (novos)
@cd_relatorio int,
@cd_tabela int,
@cd_atributo int,
--dados antes da execuçao (antigos)
@cd_relatorio_old int,
@cd_tabela_old int,
@cd_atributo_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Relatorio_Atributo SET          cd_relatorio = @cd_relatorio,
         cd_tabela = @cd_tabela,
         cd_atributo = @cd_atributo     WHERE
         cd_relatorio = @cd_relatorio_old and 
         cd_tabela = @cd_tabela_old and 
         cd_atributo = @cd_atributo_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

