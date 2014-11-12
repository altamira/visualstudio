
CREATE procedure sp_AlteraNivelAcesso
--dados depois da execuçao (novos)
@cd_nivel_acesso int,
@nm_nivel_acesso varchar (40),
@ic_menu_visivel char (1),
@ic_senha_acesso char (1),
@ic_inclusao char (1),
@ic_alteracao char (1),
@ic_consulta char (1),
@ic_exclusao char (1),
@ic_relatorio char (1),
--dados antes da execuçao (antigos)
@cd_nivel_acesso_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE NivelAcesso SET
         cd_nivel_acesso = @cd_nivel_acesso,
         nm_nivel_acesso = @nm_nivel_acesso,
         ic_menu_visivel = @ic_menu_visivel,
         ic_senha_acesso = @ic_senha_acesso,
         ic_inclusao = @ic_inclusao,
         ic_alteracao = @ic_alteracao,
         ic_consulta = @ic_consulta,
         ic_exclusao = @ic_exclusao,
         ic_relatorio = @ic_relatorio
     WHERE
         cd_nivel_acesso = @cd_nivel_acesso_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

