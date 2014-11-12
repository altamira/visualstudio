CREATE TABLE [dbo].[Previsao_Contabil] (
    [cd_previsao_contabil] INT          NOT NULL,
    [dt_previsao_contabil] DATETIME     NULL,
    [cd_planta]            INT          NULL,
    [cd_lote]              INT          NULL,
    [ds_previsao_contabil] TEXT         NULL,
    [cd_usuario_aprovacao] INT          NULL,
    [dt_usuario_aprovacao] DATETIME     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_previsao_contabil] VARCHAR (40) NULL,
    CONSTRAINT [PK_Previsao_Contabil] PRIMARY KEY CLUSTERED ([cd_previsao_contabil] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Previsao_Contabil_Planta] FOREIGN KEY ([cd_planta]) REFERENCES [dbo].[Planta] ([cd_planta])
);

