
CREATE procedure sp_InsereMenu
@cd_menu int output,
@nm_menu varchar (40) output,
@nm_menu_titulo varchar (60) output,
@ic_menu_visivel char (1) output,
@nm_mensagem_menu varchar (40) output,
@ds_observacao text output,
@cd_senha_acesso_menu char (10) output,
@nm_form_menu varchar (40) output,
@nm_unit_menu char (40) output,
@cd_tipo_menu int output,
@cd_nivel_acesso int output,
@cd_imagem int output,
@cd_help int output,
@cd_menu_superior int,
@cd_classe int,
@ic_mdi char(1),
@cd_usuario int,
@dt_usuario datetime,
@sg_tipo_opcao char(1),
@nm_executavel varchar(100),
@ic_alteracao char(1),
@ic_grafico_menu char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_menu = ISNULL(MAX(cd_menu),0) + 1 FROM Menu TABLOCK
  INSERT INTO Menu( cd_menu,
                    nm_menu,
                    nm_menu_titulo,
                    ic_menu_visivel,
                    nm_mensagem_menu,
                    ds_observacao,
                    cd_senha_acesso_menu,
                    nm_form_menu,
                    nm_unit_menu,
                    cd_tipo_menu,
                    cd_nivel_acesso,
                    cd_imagem,
                    cd_help,
                    cd_menu_superior,
                    cd_classe,
                    ic_mdi,
                    cd_usuario,
                    dt_usuario,
                    sg_tipo_opcao,
                    nm_executavel,
                    ic_alteracao,
		    ic_grafico_menu)
     VALUES (@cd_menu,
             @nm_menu,
             @nm_menu_titulo,
             @ic_menu_visivel,
             @nm_mensagem_menu,
             @ds_observacao,
             @cd_senha_acesso_menu,
             @nm_form_menu,
             @nm_unit_menu,
             @cd_tipo_menu,
             @cd_nivel_acesso,
             @cd_imagem,
             @cd_help,
             @cd_menu_superior,
             @cd_classe,
             @ic_mdi,
             @cd_usuario,
             @dt_usuario,
             @sg_tipo_opcao,
             @nm_executavel,
             @ic_alteracao,
	     @ic_grafico_menu )
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON


