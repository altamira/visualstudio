CREATE TABLE [dbo].[Serie_Produto_Furo] (
    [cd_serie_produto]          INT          NOT NULL,
    [cd_tipo_serie_produto]     INT          NOT NULL,
    [cd_item_serie_prod_compon] INT          NOT NULL,
    [cd_furo_serie_produto]     INT          NOT NULL,
    [cd_tipo_furo]              INT          NULL,
    [qt_furo_serie_produto]     FLOAT (53)   NULL,
    [nm_obs_furo_serie_produto] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Serie_Produto_Furo] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie_produto] ASC, [cd_item_serie_prod_compon] ASC, [cd_furo_serie_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Furo_Tipo_Furo] FOREIGN KEY ([cd_tipo_furo]) REFERENCES [dbo].[Tipo_Furo] ([cd_tipo_furo])
);

