CREATE TABLE [dbo].[Solicitacao_Adiantamento_Contabil] (
    [cd_contab_adiantamento] INT          NOT NULL,
    [dt_contab_adiantamento] DATETIME     NULL,
    [cd_solicitacao]         INT          NULL,
    [cd_lancamento_padrao]   INT          NULL,
    [cd_conta_debito]        INT          NULL,
    [cd_conta_credito]       INT          NULL,
    [cd_historico_contabil]  INT          NULL,
    [nm_historico_contabil]  VARCHAR (40) NULL,
    [ic_sct_adiantamento]    CHAR (1)     NULL,
    [dt_sct_adiantamento]    DATETIME     NULL,
    [vl_contab_adiantamento] FLOAT (53)   NULL,
    [cd_lote_contabil]       INT          NULL,
    [ic_manutencao_contabil] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_contabilizado]       CHAR (1)     NULL,
    [cd_lancamento_contabil] INT          NULL,
    CONSTRAINT [PK_Solicitacao_Adiantamento_Contabil] PRIMARY KEY CLUSTERED ([cd_contab_adiantamento] ASC) WITH (FILLFACTOR = 90)
);

