

CREATE procedure sp_AlteraFuncao
--dados depois da execuçao (novos)
@nm_funcao varchar (20),
@ds_funcao text,
--dados antes da execuçao (antigos)
@cd_funcao_old int,
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Funcao SET          
         nm_funcao = @nm_funcao,
         ds_funcao = @ds_funcao,
         cd_usuario = @cd_usuario,
         dt_usuario = @dt_usuario,
         ic_alteracao = @ic_alteracao
     WHERE
         cd_funcao = @cd_funcao_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON



