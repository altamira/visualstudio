
create procedure sp_AlteraUsuario_Empresa
--dados depois da execuçao (novos)
@cd_usuario int,
@cd_empresa int,
--dados antes da execuçao (antigos)
@cd_usuario_old int,
@cd_empresa_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Usuario_Empresa SET          cd_usuario = @cd_usuario,
         cd_empresa = @cd_empresa     WHERE
         cd_usuario = @cd_usuario_old and 
         cd_empresa = @cd_empresa_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

