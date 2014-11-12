
CREATE procedure sp_AlteraImagem
--dados depois da execuçao (novos)
@cd_imagem int,
@nm_imagem varchar (30),
@sg_imagem char (10),
@nm_arquivo_imagem varchar (50),
@nm_local_imagem varchar (50),
--dados antes da execuçao (antigos)
@cd_imagem_old int,
@cd_usuario_atualiza int,
@dt_usuario datetime,
@ic_alteracao char(1)
/*
@nm_imagem_old varchar (30),
@sg_imagem_old char (10),
@nm_arquivo_imagem_old varchar (50),
@nm_local_imagem_old varchar (50)
*/
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Imagem SET          
         cd_imagem = @cd_imagem,
         nm_imagem = @nm_imagem,
         sg_imagem = @sg_imagem,
         nm_arquivo_imagem = @nm_arquivo_imagem,
         nm_local_imagem = @nm_local_imagem,
         cd_usuario_atualiza = @cd_usuario_atualiza,
         dt_usuario = @dt_usuario,
         ic_alteracao = @ic_alteracao
     WHERE
         cd_imagem = @cd_imagem_old
/* and 
         nm_imagem = @nm_imagem_old and 
         sg_imagem = @sg_imagem_old and 
         nm_arquivo_imagem = @nm_arquivo_imagem_old and 
         nm_local_imagem = @nm_local_imagem_old
*/
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

