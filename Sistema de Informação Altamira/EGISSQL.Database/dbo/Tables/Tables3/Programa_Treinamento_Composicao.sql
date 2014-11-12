CREATE TABLE [dbo].[Programa_Treinamento_Composicao] (
    [cd_programa]              INT          NOT NULL,
    [cd_item_programa]         INT          NOT NULL,
    [qt_item_ordem]            FLOAT (53)   NULL,
    [cd_exercicio]             INT          NULL,
    [cd_aparelho]              INT          NULL,
    [qt_serie_exercicio]       INT          NULL,
    [qt_repeticacao_exercicio] FLOAT (53)   NULL,
    [qt_peso_exercicio]        FLOAT (53)   NULL,
    [nm_obs_exercicio]         VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Programa_Treinamento_Composicao] PRIMARY KEY CLUSTERED ([cd_programa] ASC, [cd_item_programa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programa_Treinamento_Composicao_Aparelho] FOREIGN KEY ([cd_aparelho]) REFERENCES [dbo].[Aparelho] ([cd_aparelho])
);

