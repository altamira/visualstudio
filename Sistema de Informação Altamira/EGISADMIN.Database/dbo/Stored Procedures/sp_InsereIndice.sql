
CREATE procedure sp_InsereIndice
@cd_tabela int output,
@cd_indice int output,
@nm_indice varchar (40),
@ic_clustered char (1),
@pc_fill_factor float (50),
@ic_unico char (1) output,
@ic_temporario char (1),
@nm_descricao varchar(150),
@cd_usuario_atualiza int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_indice = ISNULL(MAX(cd_indice),0) + 1 FROM Indice TABLOCK
    WHERE cd_tabela = @cd_tabela
  INSERT INTO Indice( cd_tabela,
                      cd_indice,
                      nm_indice,
                      ic_clustered,
                      pc_fill_factor,
                      ic_unico,
                      ic_temporario,
                      nm_descricao,
                      cd_usuario_atualiza,
                      dt_usuario,
                      ic_alteracao )
     VALUES (@cd_tabela,
             @cd_indice,
             @nm_indice,
             @ic_clustered,
             @pc_fill_factor,
             @ic_unico,
             @ic_temporario,
             @nm_descricao,
             @cd_usuario_atualiza,
             @dt_usuario,
             @ic_alteracao)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

