CREATE TABLE [dbo].[Laudo_Padrao_Caracteristica] (
    [cd_laudo_padrao]         INT           NOT NULL,
    [cd_item_laudo_padrao]    INT           NOT NULL,
    [cd_caracteristica_laudo] INT           NULL,
    [nm_especificacao]        VARCHAR (100) NULL,
    [nm_metodo]               VARCHAR (100) NULL,
    [nm_obs_caracteristica]   VARCHAR (60)  NULL,
    [cd_tolerancia_produto]   INT           NULL,
    [nm_tolerancia_laudo]     VARCHAR (15)  NULL,
    [cd_unidade_medida]       INT           NULL,
    [cd_tipo_medicao]         INT           NULL,
    [nm_plano_medicao]        VARCHAR (20)  NULL,
    [cd_ferramenta]           INT           NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Laudo_Padrao_Caracteristica] PRIMARY KEY CLUSTERED ([cd_laudo_padrao] ASC, [cd_item_laudo_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Padrao_Caracteristica_Ferramenta] FOREIGN KEY ([cd_ferramenta]) REFERENCES [dbo].[Ferramenta] ([cd_ferramenta])
);

