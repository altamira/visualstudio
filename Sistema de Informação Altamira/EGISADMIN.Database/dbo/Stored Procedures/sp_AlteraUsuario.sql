
CREATE procedure sp_AlteraUsuario
--dados depois da execuçao (novos)
@cd_usuario                  int output,
@nm_usuario                  varchar (40),
@nm_fantasia_usuario         char (15),
@cd_senha_usuario            varchar (10),
@ic_tipo_usuario             char (1),
@dt_validade_senha_usuario   datetime,
@qt_tentativa_acesso_usuario int,
@dt_nascimento_usuario       datetime,
@ic_controle_aniversario     char (1),
@nm_email_usuario            char (50),
@nm_ramal_usuario            char (10),
@cd_telefone_usuario         char (8),
@cd_celular_usuario          char (8),
@nm_arquivo_foto_usuario     varchar (50),
@dt_cadastro_usuario         datetime,
@cd_usuario_old              int,
@nm_local_arquivo_usuario    varchar(70),
@qt_dias_troca               int,
@ic_consulta_executiva       char(1),
@ic_consulta_comissao_total  char(1),
@cd_vendedor                 int,
@ic_alterar_primeiro_log     char(1),
@ic_ativo                    char(1),
@cd_departamento             int,
@ic_moeda_usuario            char(1),
@ic_lista_aniversariantes    char(1),
@ic_wapnet_usuario           char(1),
@cd_senha_wapnet_usuario     char(3),
@ic_repnet_usuario           char(1),
@cd_senha_repnet_usuario     char(10),
@cd_senha_email              varchar(10),
@nm_usuario_email            varchar(30),
@nm_assinatura_usuario       varchar(100),
@ic_dica_usuario char(1),
@cd_cargo_empresa int,
@ic_lembrete_usuario char(1),
@ic_ass_eletronica_usuario  char(1),
@ic_operador_tmkt_usuario   char(1),
@ic_acesso_internet_usuario char(1),
@cd_usuario_atualiza        int,
@dt_usuario_atualiza        datetime,
@cd_comprador               int,
@ic_ocorrencia_usuario      char(1),
@cd_tipo_aprovacao          int,
@ic_bx_req_interna_usuario  char(1),
@cd_idioma                  int,
@ic_multi_idioma_usuario    char(1),
@ic_autoriza_pagamento      char(1) = 'N',
@cd_loja                    int = 0,
@ic_instrucao_usuario       char(1) = 'N',
@cd_centro_custo            int = 0,
@cd_projetista              int = 0,
@ic_exportacao_usuario      char(1) = 'N',
@ic_email_usuario           char(1) = 'N',
@ic_acesso_padrao_usuario   char(1) = 'N',
@ic_bx_req_fab_usuario      char(1) = 'N',
@cd_funcionario             int     = 0,
@ic_moeda_nacional          char(1) = 'N',
@ic_moeda_estrangeira       char(1) = 'N',
@ic_bloqueio_vendedor       char(1) = 'N'

AS

BEGIN

  DECLARE @Loginame sysname,
          @cd_senha_usuario_old varchar (10)

  -- armazena a senha anterior
  SELECT @cd_senha_usuario_old = cd_senha_usuario from usuario
       WHERE cd_usuario = @cd_usuario_old
  -- armazena o login name
  SELECT @loginame = nm_fantasia_usuario FROM usuario 
       WHERE cd_usuario = @cd_usuario_old
  IF @cd_senha_usuario_old <> @cd_senha_usuario 
  BEGIN
      /* valida a senha informada */
      IF exists(SELECT * 
                  FROM Historico_Senha_Usuario 
                 WHERE cd_usuario = @cd_usuario
                   AND cd_senha_usuario = @cd_senha_usuario)
      BEGIN
         GOTO TrataErro 
         RETURN
      END
  END
--  EXEC sp_RevokeDBAccess @loginame
  -- apaga o login do usuario
--  EXEC sp_DropLogin @loginame
  -- ajusta espaços da senha
  SELECT @cd_senha_usuario = RTrim(Ltrim(@cd_senha_usuario)) 
  select @cd_senha_usuario
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Usuario SET
         nm_usuario                  = @nm_usuario,
         nm_fantasia_usuario         = @nm_fantasia_usuario,
         cd_senha_usuario            = @cd_senha_usuario,
         ic_tipo_usuario             = @ic_tipo_usuario,
         dt_validade_senha_usuario   = @dt_validade_senha_usuario,
         qt_tentativa_acesso_usuario = @qt_tentativa_acesso_usuario,
         dt_nascimento_usuario       = @dt_nascimento_usuario,
         ic_controle_aniversario     = @ic_controle_aniversario,
         nm_email_usuario            = @nm_email_usuario,
         nm_ramal_usuario            = @nm_ramal_usuario,
         cd_telefone_usuario         = @cd_telefone_usuario,
         cd_celular_usuario          = @cd_celular_usuario,
         nm_arquivo_foto_usuario     = @nm_arquivo_foto_usuario,
         dt_cadastro_usuario         = @dt_cadastro_usuario,
         nm_local_arquivo_usuario    = @nm_local_arquivo_usuario,
         qt_dias_troca               = @qt_dias_troca,
         ic_consulta_executiva       = @ic_consulta_executiva,
	       ic_consulta_comissao_total  = @ic_consulta_comissao_total,
         cd_vendedor                 = @cd_vendedor,
      	 ic_alterar_primeiro_log     = @ic_alterar_primeiro_log,
      	 ic_ativo 		               = @ic_ativo,
      	 cd_departamento	           = @cd_departamento,
     	   ic_moeda_usuario	           = @ic_moeda_usuario,
      	 ic_lista_aniversariantes    = @ic_lista_aniversariantes,
      	 ic_wapnet_usuario           = @ic_wapnet_usuario,
      	 cd_senha_wapnet_usuario     = @cd_senha_wapnet_usuario,
      	 ic_repnet_usuario           = @ic_repnet_usuario,
      	 cd_senha_repnet_usuario     = @cd_senha_repnet_usuario,
	 cd_senha_email              = @cd_senha_email,
	 nm_usuario_email            = @nm_usuario_email,
	 nm_assinatura_usuario       = @nm_assinatura_usuario,
	 ic_dica_usuario             = @ic_dica_usuario,
	 cd_cargo_empresa	     = @cd_cargo_empresa,
         ic_lembrete_usuario         = @ic_lembrete_usuario,
	 ic_ass_eletronica_usuario   = @ic_ass_eletronica_usuario,
	 ic_operador_tmkt_usuario    = @ic_operador_tmkt_usuario,
	 ic_acesso_internet_usuario  = @ic_acesso_internet_usuario,
         cd_usuario_atualiza	     = @cd_usuario_atualiza,
         dt_usuario_atualiza         = @dt_usuario_atualiza,
         cd_comprador                = @cd_comprador,
         ic_ocorrencia_usuario       = @ic_ocorrencia_usuario,
	 cd_tipo_aprovacao	     = @cd_tipo_aprovacao,
	 ic_bx_req_interna_usuario   = @ic_bx_req_interna_usuario,
         cd_idioma                   = @cd_idioma,
         ic_multi_idioma_usuario     = @ic_multi_idioma_usuario,
         ic_autoriza_pagamento       = @ic_autoriza_pagamento,
	 cd_loja 		     = @cd_loja,
         ic_instrucao_usuario        = @ic_instrucao_usuario,
         cd_centro_custo             = @cd_centro_custo,
         cd_projetista               = @cd_projetista,
         ic_exportacao_usuario       = @ic_exportacao_usuario,
         ic_email_usuario            = @ic_email_usuario,
         ic_acesso_padrao_usuario    = @ic_acesso_padrao_usuario,
         ic_bx_req_fab_usuario       = @ic_bx_req_fab_usuario,
         cd_funcionario              = @cd_funcionario,
         ic_moeda_nacional           = @ic_moeda_nacional,     
         ic_moeda_estrangeira        = @ic_moeda_estrangeira,  
         ic_bloqueio_vendedor        = @ic_bloqueio_vendedor
     WHERE
         cd_usuario                  = @cd_usuario_old

  /* atualiza o histórico de senhas */

  if @cd_senha_usuario_old <> @cd_senha_usuario
    INSERT INTO Historico_Senha_Usuario
    (dt_troca_senha,
     cd_usuario,
     cd_senha_usuario,
     cd_usuario_atualiza,
     dt_atualiza,
     dt_usuario)     
   VALUES 
    (GetDate(),
     @cd_usuario,
     @cd_senha_usuario,
     @cd_usuario_atualiza, 
     @dt_usuario_atualiza, 
     @dt_usuario_atualiza)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
  -- adiciona o login do usuario ao servidor
  SELECT @nm_fantasia_usuario = nm_fantasia_usuario FROM Usuario
     WHERE cd_usuario = @cd_usuario_old
  SELECT @cd_senha_usuario = cd_senha_usuario FROM Usuario
     WHERE cd_usuario = @cd_usuario_old
  -- se trocou loginame, adiciona o novo 
  if @loginame <> @nm_fantasia_usuario
  begin
--    EXEC SP_ADDLOGIN @nm_fantasia_usuario,@cd_senha_usuario,'master','Português'
    if not exists(Select 'x' from master.dbo.sysxlogins where name = @nm_fantasia_usuario)
       EXEC SP_ADDLOGIN @nm_fantasia_usuario,'STANDARDPASSWORD','master','Português'
    if not exists(Select 'x' from sysusers where name = @nm_fantasia_usuario)
       EXEC SP_GRANTDBACCESS @nm_fantasia_usuario
    EXEC SP_ADDROLEMEMBER 'db_owner', @nm_fantasia_usuario
  end
  else
    -- se nao, verifica se trocou a senha 
--    if @cd_senha_usuario_old <> @cd_senha_usuario 
--      exec sp_password null, @cd_senha_usuario, @nm_fantasia_usuario
      exec sp_password null, 'STANDARDPASSWORD', @nm_fantasia_usuario
end
TRATAERRO:
  RAISERROR ('Esta senha já foi utilizada.',16,1)




