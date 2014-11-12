CREATE TABLE [dbo].[Previsao_Contabil_Composicao] (
    [cd_previsao_contabil]     INT          NOT NULL,
    [cd_item_previsao]         INT          NOT NULL,
    [cd_conta]                 INT          NULL,
    [cd_centro_custo]          INT          NULL,
    [cd_planta]                INT          NULL,
    [vl_lancamento_previsao]   FLOAT (53)   NULL,
    [cd_historico_contabil]    INT          NULL,
    [nm_complemento_historico] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Previsao_Contabil_Composicao] PRIMARY KEY CLUSTERED ([cd_previsao_contabil] ASC, [cd_item_previsao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Previsao_Contabil_Composicao_Planta] FOREIGN KEY ([cd_planta]) REFERENCES [dbo].[Planta] ([cd_planta])
);

