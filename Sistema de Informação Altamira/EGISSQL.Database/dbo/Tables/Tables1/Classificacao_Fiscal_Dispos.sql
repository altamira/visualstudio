CREATE TABLE [dbo].[Classificacao_Fiscal_Dispos] (
    [cd_classificacao_fiscal] INT          NOT NULL,
    [cd_dispositivo_legal]    INT          NOT NULL,
    [cd_item_dispositivo]     INT          NOT NULL,
    [nm_obs_item_dispositivo] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Fiscal_Dispos] PRIMARY KEY CLUSTERED ([cd_classificacao_fiscal] ASC, [cd_dispositivo_legal] ASC, [cd_item_dispositivo] ASC) WITH (FILLFACTOR = 90)
);

