
CREATE procedure sp_AlteraIndice
--dados depois da execuçao (novos)
@cd_tabela int,
@cd_indice int,
@nm_indice varchar (40),
@ic_clustered char (1),
@pc_fill_factor float (50),
@ic_unico char (1),
@ic_temporario char(1),
@nm_descricao varchar(150),
--dados antes da execuçao (antigos)
@cd_tabela_old int,
@cd_indice_old int,
@cd_usuario_atualiza int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Indice SET
         cd_tabela      = @cd_tabela,
         cd_indice      = @cd_indice,
         nm_indice      = @nm_indice,
         ic_clustered   = @ic_clustered,
         pc_fill_factor = @pc_fill_factor,
         ic_unico       = @ic_unico,
         ic_temporario  = @ic_temporario,
         nm_descricao   = @nm_descricao,
         cd_usuario_atualiza = @cd_usuario_atualiza,
         dt_usuario = @dt_usuario,
         ic_alteracao = @ic_alteracao
     WHERE
         cd_tabela = @cd_tabela_old and 
         cd_indice = @cd_indice_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

