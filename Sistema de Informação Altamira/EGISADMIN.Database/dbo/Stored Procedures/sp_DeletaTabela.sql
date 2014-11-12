
CREATE procedure sp_DeletaTabela
--dados antes da execuçao (antigos)
@cd_tabela int
/*
,
@nm_tabela varchar(30),
@ds_tabela varchar(50),
@ic_tipo_tabela char(1),
@dt_criacao_tabela datetime,
@dt_alteracao_tabela datetime,
@ic_controle_numeracao char(1),
@cd_tabela_dbf int,
@ic_repnet char(1),
@ic_clinet char(1),
@ic_fornet char(1),
@ic_sap_dbf char(1)
*/
as
begin
  -- inicia a transaçao
  BEGIN TRAN
  DELETE FROM Atributo
    WHERE 
         cd_tabela              = @cd_tabela
  -- atualizaçao
  DELETE FROM Tabela
    WHERE
         cd_tabela              = @cd_tabela
/*
 and
         nm_tabela              = @nm_tabela and
         ds_tabela              = @ds_tabela and
         ic_tipo_tabela         = @ic_tipo_tabela and
         dt_criacao_tabela      = @dt_criacao_tabela and
         dt_alteracao_tabela    = @dt_alteracao_tabela and
         ic_controle_numeracao  = @ic_controle_numeracao and
         cd_tabela_dbf          = @cd_tabela_dbf and
         ic_repnet              = @ic_repnet and
         ic_clinet              = @ic_clinet and
         ic_fornet              = @ic_fornet and
         ic_sap_dbf             = @ic_sap_dbf
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

