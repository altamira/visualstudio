CREATE TABLE [dbo].[Ato_Concessorio_Composicao] (
    [cd_ato_concessorio]      INT          NOT NULL,
    [cd_item_ato_concessorio] INT          NOT NULL,
    [cd_classificacao_fiscal] INT          NULL,
    [qt_item_ato]             FLOAT (53)   NULL,
    [qt_item_saldo_ato]       FLOAT (53)   NULL,
    [nm_Item_obs_ato]         VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Ato_Concessorio_Composicao] PRIMARY KEY CLUSTERED ([cd_ato_concessorio] ASC, [cd_item_ato_concessorio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ato_Concessorio_Composicao_Classificacao_Fiscal] FOREIGN KEY ([cd_classificacao_fiscal]) REFERENCES [dbo].[Classificacao_Fiscal] ([cd_classificacao_fiscal])
);

