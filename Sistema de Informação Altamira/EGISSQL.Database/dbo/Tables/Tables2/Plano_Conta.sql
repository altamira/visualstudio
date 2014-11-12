CREATE TABLE [dbo].[Plano_Conta] (
    [cd_empresa]             INT          NOT NULL,
    [cd_conta]               INT          NOT NULL,
    [cd_mascara_conta]       VARCHAR (20) NULL,
    [nm_conta]               VARCHAR (40) NULL,
    [ic_tipo_conta]          CHAR (1)     NULL,
    [ic_conta_analitica]     CHAR (1)     NULL,
    [ic_conta_balanco]       CHAR (1)     NULL,
    [ic_conta_resultado]     CHAR (1)     NULL,
    [ic_conta_custo]         CHAR (1)     NULL,
    [ic_conta_analise]       CHAR (1)     NULL,
    [ic_situacao_conta]      CHAR (1)     NULL,
    [ic_lancamento_conta]    CHAR (1)     NULL,
    [vl_saldo_inicial_conta] FLOAT (53)   NULL,
    [ic_saldo_inicial_conta] CHAR (1)     NULL,
    [vl_debito_conta]        FLOAT (53)   NULL,
    [vl_credito_conta]       FLOAT (53)   NULL,
    [qt_lancamento_conta]    INT          NULL,
    [vl_saldo_atual_conta]   FLOAT (53)   NULL,
    [ic_saldo_atual_conta]   CHAR (1)     NULL,
    [cd_grupo_conta]         INT          NULL,
    [cd_conta_reduzido]      INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [qt_grau_conta]          INT          NULL,
    [cd_conta_sintetica]     INT          NULL,
    [ic_conta_demonstrativo] CHAR (1)     NULL,
    [cd_centro_custo]        INT          NULL,
    [cd_centro_receita]      INT          NULL,
    [nm_obs_plano_conta]     VARCHAR (40) NULL,
    [cd_interface]           INT          NULL,
    [ic_redutora_conta]      CHAR (1)     NULL,
    [ic_neutral_conta]       CHAR (1)     NULL,
    [ic_variacao_conta]      CHAR (1)     NULL,
    CONSTRAINT [PK_Plano_Conta] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_conta] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Conta_cd_conta_reduzido]
    ON [dbo].[Plano_Conta]([cd_conta_reduzido] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Conta_nm_conta]
    ON [dbo].[Plano_Conta]([nm_conta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Conta_cd_conta_sintetica]
    ON [dbo].[Plano_Conta]([cd_conta_sintetica] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Conta_cd_mascara_conta]
    ON [dbo].[Plano_Conta]([cd_mascara_conta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Conta_cd_empresa]
    ON [dbo].[Plano_Conta]([cd_empresa] ASC) WITH (FILLFACTOR = 90);


GO
--tr_apagar_plano_conta
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Plano de Contas
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_plano_conta on dbo.Plano_Conta
for delete
as
begin
  declare @cd_conta_reduzido int
  declare @cd_empresa int
  declare @cd_mascara_conta varchar(20)
  select 
    @cd_conta_reduzido = cd_conta_reduzido,
    @cd_empresa        = cd_empresa,
    @cd_mascara_conta  = cd_mascara_conta
  from 
    deleted
  if exists(select
              cd_lancamento_contabil
            from
              movimento_contabil
            where
              (cd_reduzido_debito = @cd_conta_reduzido or
              cd_reduzido_credito = @cd_conta_reduzido) and
              cd_empresa = @cd_empresa)
    begin
      raiserror('Deleçao nao Permitida. Existem Lançamentos Contábeis usando esta Conta.',16,1)
      rollback transaction
    end
  else    
    begin
      if exists(select
                  cd_conta
                from
                  Plano_conta
                where
                  cd_mascara_conta like @cd_mascara_conta+'[.^]%' and
                  cd_empresa = @cd_empresa)
        begin
          raiserror('Deleçao nao Permitida. Existem Contas Analíticas que participam desta conta Sintética.',16,1)
          rollback transaction
        end
      else  
        begin
          if exists(select
                      cd_conta
                    from
                      Plano_conta
                    where
                      vl_saldo_inicial_conta <> 0 and
                      vl_debito_conta <> 0 and
                      vl_credito_conta <> 0 and
                      vl_saldo_atual_conta <> 0 and
                      cd_conta_reduzido = @cd_conta_reduzido and
                      cd_empresa = @cd_empresa)
            begin
              raiserror('Deleçao nao Permitida. Conta com Saldo.', 16, 1)
              rollback transaction
            end
        end
    end                      
end
