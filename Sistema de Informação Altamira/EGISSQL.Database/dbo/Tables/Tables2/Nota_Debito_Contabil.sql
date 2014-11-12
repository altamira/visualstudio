CREATE TABLE [dbo].[Nota_Debito_Contabil] (
    [cd_nota_debito]            INT          NOT NULL,
    [cd_it_ctb_documento]       INT          NOT NULL,
    [dt_contab_documento]       DATETIME     NOT NULL,
    [cd_lancamento_padrao]      INT          NOT NULL,
    [cd_conta_debito]           INT          NOT NULL,
    [cd_conta_credito]          INT          NOT NULL,
    [vl_contab_documento]       FLOAT (53)   NOT NULL,
    [cd_historico_contabil]     INT          NOT NULL,
    [nm_historico_documento]    VARCHAR (40) NULL,
    [ic_sct_contab_documento]   CHAR (1)     NULL,
    [dt_sct_contabil_documento] DATETIME     NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Nota_Debito_Contabil] PRIMARY KEY CLUSTERED ([cd_nota_debito] ASC, [cd_it_ctb_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Debito_Contabil_Historico_Contabil] FOREIGN KEY ([cd_historico_contabil]) REFERENCES [dbo].[Historico_Contabil] ([cd_historico_contabil])
);

