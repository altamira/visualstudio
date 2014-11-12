
CREATE procedure sp_AlteraMenu
--dados depois da execuçao (novos)
@nm_menu varchar (40),
@nm_menu_titulo varchar (60),
@ic_menu_visivel char (1),
@nm_mensagem_menu varchar (40),
@ds_observacao text,
@cd_senha_acesso_menu char (10),
@nm_form_menu varchar (40),
@nm_unit_menu char (40),
@cd_tipo_menu int,
@cd_nivel_acesso int,
@cd_imagem int,
@cd_help int,
@cd_menu_superior int,
@cd_classe int,
@ic_mdi char(1),
@cd_usuario int,
@dt_usuario datetime,
@sg_tipo_opcao char(1),
@nm_executavel varchar(100),
@ic_alteracao char(1),
@ic_grafico_menu char(1),
--dados antes da execuçao (antigos)
@cd_menu_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Menu SET
         nm_menu              = @nm_menu,
         nm_menu_titulo       = @nm_menu_titulo,
         ic_menu_visivel      = @ic_menu_visivel,
         nm_mensagem_menu     = @nm_mensagem_menu,
         ds_observacao        = @ds_observacao,
         cd_senha_acesso_menu = @cd_senha_acesso_menu,
         nm_form_menu         = @nm_form_menu,
         nm_unit_menu         = @nm_unit_menu,
         cd_tipo_menu         = @cd_tipo_menu,
         cd_nivel_acesso      = @cd_nivel_acesso,
         cd_imagem            = @cd_imagem,
         cd_help              = @cd_help,
         cd_menu_superior     = @cd_menu_superior,
         cd_classe            = @cd_classe,
         ic_mdi               = @ic_mdi,
         cd_usuario           = @cd_usuario,
         dt_usuario           = @dt_usuario, 
         sg_tipo_opcao        = @sg_tipo_opcao,
         nm_executavel        = @nm_executavel,
         ic_alteracao         = @ic_alteracao, 
	 ic_grafico_menu      = @ic_grafico_menu
   WHERE
         cd_menu              = @cd_menu_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON


