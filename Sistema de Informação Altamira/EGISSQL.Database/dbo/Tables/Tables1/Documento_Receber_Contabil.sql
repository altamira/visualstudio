CREATE TABLE [dbo].[Documento_Receber_Contabil] (
    [cd_documento_receber]      INT          NOT NULL,
    [cd_item_contab_documento]  INT          NOT NULL,
    [dt_contab_documento]       DATETIME     NULL,
    [cd_lancamento_padrao]      INT          NULL,
    [cd_conta_credito]          INT          NULL,
    [cd_conta_debito]           INT          NULL,
    [vl_contab_documento]       FLOAT (53)   NULL,
    [cd_historico_contabil]     INT          NULL,
    [nm_historico_documento]    VARCHAR (40) NULL,
    [ic_sct_contab_documento]   CHAR (1)     NULL,
    [dt_sct_contabil_documento] DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_lote_contabil]          INT          NULL,
    CONSTRAINT [PK_Documento_Receber_Contabil] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [cd_item_contab_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Contabil_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber]) ON DELETE CASCADE ON UPDATE CASCADE
);

