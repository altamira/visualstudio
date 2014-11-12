

CREATE  procedure sp_AlteraTabela
--dados antes da execuçao (antigos)
@cd_tabela_old int,
--dados depois da execuçao (novos)
@nm_tabela varchar(100), 
@ds_tabela varchar(50),
@ic_tipo_tabela char(1),
@dt_criacao_tabela datetime,
@dt_alteracao_tabela datetime,
@ic_controle_numeracao char(1),
@cd_tabela_dbf int,
@ic_repnet char(1),
@ic_clinet char(1),
@ic_fornet char(1),
@ic_sap_dbf char(1),
@ic_migracao_concluida char(1),
@ds_obs_tabela text,
@ic_sap_admin char(1),
@cd_usuario int,
@dt_usuario datetime,
@ic_filtra_periodo char(1),
@ic_filtra_empresa char(1),
@ic_supervisor_altera char(1),
@ic_alteracao char(1),
@ic_fixa_tabela char(1),
@ic_implantacao_tabela char(1),
@ic_vincular_cadeia_valor char(1),
@cd_prioridade_tabela     int,
@ic_parametro_tabela char(1),
@ic_inativa_tabela char(1),
@ic_nucleo_tabela char(1),
@ic_publica_tabela char(1),
@cd_banco_dados int,
@ic_selecao_tabela char(1),
@ic_versao_tabela  char(1) = 'N',
@cd_ordem_tabela   int     = 0

as
begin
  SET ANSI_NULLS ON
  -- inicia a transaçao
  BEGIN TRAN
  -- atualizaçao
  UPDATE Tabela set
         nm_tabela               = @nm_tabela,
         ds_tabela               = @ds_tabela,
         ic_tipo_tabela          = @ic_tipo_tabela,
         dt_criacao_tabela       = @dt_criacao_tabela,
         dt_alteracao_tabela     = @dt_alteracao_tabela,
         ic_controle_numeracao   = @ic_controle_numeracao,
         cd_tabela_dbf           = @cd_tabela_dbf,
         ic_repnet               = @ic_repnet,
         ic_clinet               = @ic_clinet, 
         ic_fornet               = @ic_fornet, 
         ic_sap_dbf              = @ic_sap_dbf,
         ic_migracao_concluida   = @ic_migracao_concluida,
         ds_obs_tabela           = @ds_obs_tabela,
         ic_sap_admin            = @ic_sap_admin,
         cd_usuario              = @cd_usuario,
         dt_usuario              = @dt_usuario,
         ic_filtra_periodo       = @ic_filtra_periodo,
         ic_filtra_empresa       = @ic_filtra_empresa,
         ic_supervisor_altera    = @ic_supervisor_altera,
         ic_alteracao            = @ic_alteracao,
         ic_fixa_tabela          = @ic_fixa_tabela,         
         ic_implantacao_tabela   = @ic_implantacao_tabela,
         ic_vincular_cadeia_valor= @ic_vincular_cadeia_valor,
         cd_prioridade_tabela    = @cd_prioridade_tabela,
	 ic_parametro_tabela     = @ic_parametro_tabela,
         ic_inativa_tabela       = @ic_inativa_tabela,
         ic_nucleo_tabela        = @ic_nucleo_tabela,
         ic_publica_tabela       = @ic_publica_tabela,
         cd_banco_dados          = @cd_banco_dados,
         ic_selecao_tabela       = @ic_selecao_tabela,
         ic_versao_tabela        = @ic_versao_tabela,
         cd_ordem_tabela         = @cd_ordem_tabela

    WHERE
         cd_tabela              = @cd_tabela_old

  if @@ERROR = 0 
    COMMIT TRAN
  else
  begin
    --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

