
CREATE procedure sp_AlteraRelatorio
--dados depois da execuçao (novos)
@cd_relatorio int ,
@nm_relatorio varchar (40),
@sg_relatorio char (10),
--dados antes da execuçao (antigos)
@cd_relatorio_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Relatorio SET
         cd_relatorio = @cd_relatorio,
         nm_relatorio = @nm_relatorio,
         sg_relatorio = @sg_relatorio
     WHERE
         cd_relatorio = @cd_relatorio_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

