
CREATE procedure sp_InsereTabela
@cd_tabela int output,
@nm_tabela varchar(100) output, 
@ds_tabela varchar(50) output,
@ic_tipo_tabela char(1) output,
@dt_criacao_tabela datetime output,
@dt_alteracao_tabela datetime output,
@ic_controle_numeracao char(1) output,
@cd_tabela_dbf int output,
@ic_repnet char(1) output,
@ic_clinet char(1) output,
@ic_fornet char(1) output,
@ic_sap_dbf char(1) output,
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
@cd_prioridade_tabela int,
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
  -- inicia a transaçao
  BEGIN TRAN
  -- gerar codigo e executa travamento
  SELECT @cd_tabela = ISNULL(MAX(cd_tabela),0) + 1 FROM Tabela TABLOCK
  -- inserçao
  INSERT INTO Tabela (cd_tabela, 
                      nm_tabela, 
                      ds_tabela, 
                      ic_tipo_tabela, 
                      dt_criacao_tabela,
                      dt_alteracao_tabela, 
                      ic_controle_numeracao, 
                      cd_tabela_dbf,
                      ic_repnet, 
                      ic_clinet, 
                      ic_fornet, 
                      ic_sap_dbf,
                      ds_obs_tabela,
                      ic_sap_admin,
                      cd_usuario,
                      dt_usuario,
                      ic_filtra_empresa,
                      ic_filtra_periodo,
                      ic_supervisor_altera,
                      ic_alteracao,
                      ic_fixa_tabela,
                      ic_implantacao_tabela,
                      ic_vincular_cadeia_valor,
                      cd_prioridade_tabela,
            		      ic_parametro_tabela,
                      ic_inativa_tabela,
                      ic_nucleo_tabela,
                      ic_publica_tabela,
                      cd_banco_dados,
                      ic_selecao_tabela,
                      ic_versao_tabela, 
                      cd_ordem_tabela)
     VALUES (@cd_tabela, 
             @nm_tabela, 
             @ds_tabela, 
             @ic_tipo_tabela, 
             @dt_criacao_tabela, 
             @dt_alteracao_tabela,
             @ic_controle_numeracao, 
             @cd_tabela_dbf, 
             @ic_repnet,
             @ic_clinet,  
             @ic_fornet, 
             @ic_sap_dbf,
             @ds_obs_tabela,
             @ic_sap_admin,
             @cd_usuario,
             @dt_usuario,
             @ic_filtra_empresa,
             @ic_filtra_periodo,
             @ic_supervisor_altera,
             @ic_alteracao,
             @ic_fixa_tabela,
             @ic_implantacao_tabela,
             @ic_vincular_cadeia_valor,
             @cd_prioridade_tabela,
	           @ic_parametro_tabela,
             @ic_inativa_tabela,
             @ic_nucleo_tabela,
             @ic_publica_tabela,
             @cd_banco_dados,
             @ic_selecao_tabela,
             @ic_versao_tabela,
             @cd_ordem_tabela )

  if @@ERROR = 0 
    COMMIT TRAN
  else
  begin
    --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

