
CREATE procedure sp_InsereImagem
@cd_imagem int output,
@nm_imagem varchar (30) output,
@sg_imagem char (10) output,
@nm_arquivo_imagem varchar (50) output,
@nm_local_imagem varchar (50) output,
@cd_usuario_atualiza int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_imagem = ISNULL(MAX(cd_imagem),0) + 1 FROM Imagem TABLOCK
  INSERT INTO Imagem( cd_imagem,nm_imagem,sg_imagem,nm_arquivo_imagem,nm_local_imagem, 
                                                  cd_usuario_atualiza, dt_usuario, ic_alteracao)
     VALUES (@cd_imagem,@nm_imagem,@sg_imagem,@nm_arquivo_imagem,@nm_local_imagem, 
                         @cd_usuario_atualiza, @dt_usuario, @ic_alteracao)
  Select 
         @cd_imagem = cd_imagem,
         @nm_imagem = nm_imagem,
         @sg_imagem = sg_imagem,
         @nm_arquivo_imagem = nm_arquivo_imagem,
         @nm_local_imagem = nm_local_imagem
  From Imagem
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

