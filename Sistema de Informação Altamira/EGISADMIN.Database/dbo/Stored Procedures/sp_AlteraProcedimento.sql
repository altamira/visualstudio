
CREATE procedure sp_AlteraProcedimento
--dados depois da execuçao (novos)
@cd_procedimento int ,
@nm_procedimento varchar (40),
@ds_procedimento text ,
@dt_criacao_procedimento datetime,
@dt_alteracao_procedimento datetime,
@cd_usuario int,
--dados antes da execuçao (antigos)
@cd_procedimento_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Procedimento SET
         cd_procedimento           = @cd_procedimento,
         nm_procedimento           = @nm_procedimento,
         ds_procedimento           = @ds_procedimento,
         dt_criacao_procedimento   = @dt_criacao_procedimento,
         dt_alteracao_procedimento = @dt_alteracao_procedimento,
         cd_usuario = @cd_usuario
     WHERE
         cd_procedimento = @cd_procedimento_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

