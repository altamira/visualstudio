CREATE TABLE [dbo].[Divergencia_Recebimento_Composição] (
    [cd_divergencia_receb]      INT          NOT NULL,
    [cd_item_divergencia_receb] INT          NOT NULL,
    [cd_item_nota_entrada]      INT          NULL,
    [cd_irregularidade]         INT          NULL,
    [cd_produto]                INT          NULL,
    [cd_lote_produto]           INT          NULL,
    [dt_fab_produto]            DATETIME     NULL,
    [dt_validade_produto]       DATETIME     NULL,
    [nm_obs_item_produto]       VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Divergencia_Recebimento_Composição] PRIMARY KEY CLUSTERED ([cd_divergencia_receb] ASC, [cd_item_divergencia_receb] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Divergencia_Recebimento_Composição_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

