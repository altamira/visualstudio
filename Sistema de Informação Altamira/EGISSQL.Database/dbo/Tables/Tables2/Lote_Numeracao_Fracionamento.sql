CREATE TABLE [dbo].[Lote_Numeracao_Fracionamento] (
    [cd_lote_numeracao]        INT          NOT NULL,
    [cd_numero_lote]           INT          NULL,
    [nm_ref_numero_lote]       VARCHAR (15) NULL,
    [qt_passo_lote]            FLOAT (53)   NULL,
    [ic_ano_lote]              CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_estado_lote]           CHAR (1)     NULL,
    [cd_laudo]                 INT          NULL,
    [cd_produto_fracionamento] INT          NULL,
    [cd_produto]               INT          NULL,
    CONSTRAINT [FK_Lote_Numeracao_Fracionamento_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

