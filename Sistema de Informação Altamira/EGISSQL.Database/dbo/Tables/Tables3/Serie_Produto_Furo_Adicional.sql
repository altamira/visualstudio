CREATE TABLE [dbo].[Serie_Produto_Furo_Adicional] (
    [cd_serie_produto]         INT      NOT NULL,
    [cd_tipo_serie_produto]    INT      NOT NULL,
    [cd_item_serie_furo_adic]  INT      NOT NULL,
    [cd_placa]                 INT      NULL,
    [cd_montagem]              INT      NULL,
    [cd_tipo_montagem]         INT      NULL,
    [ic_montagem_g_furo_adic]  CHAR (1) NULL,
    [qt_furo_adic_serie_prod]  INT      NULL,
    [cd_tipo_furo]             INT      NULL,
    [qt_bucha_adic_serie_prod] INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_SERIE_PRODUTO_FURO_ADICIONAL] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie_produto] ASC, [cd_item_serie_furo_adic] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Furo_Adicional_Tipo_Furo] FOREIGN KEY ([cd_tipo_furo]) REFERENCES [dbo].[Tipo_Furo] ([cd_tipo_furo])
);

