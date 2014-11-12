CREATE TABLE [dbo].[Laudo_Produto_Caracteristica] (
    [cd_produto]              INT           NOT NULL,
    [cd_caracteristica_laudo] INT           NOT NULL,
    [nm_especificacao]        VARCHAR (100) NULL,
    [nm_metodo]               VARCHAR (100) NULL,
    [nm_obs_caracteristica]   VARCHAR (60)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_laudo_produto_caract] INT           NULL,
    [cd_tolerancia_produto]   INT           NULL,
    [nm_tolerancia_produto]   VARCHAR (15)  NULL,
    [cd_unidade_medida]       INT           NULL,
    [cd_tipo_medicao]         INT           NULL,
    [nm_plano_medicao]        VARCHAR (20)  NULL,
    [cd_ferramenta]           INT           NULL,
    [nm_ferramenta_laudo]     VARCHAR (40)  NULL,
    [cd_ordem_laudo]          INT           NULL,
    CONSTRAINT [PK_Laudo_Produto_Caracteristica] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_caracteristica_laudo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Produto_Caracteristica_Caracteristica_Laudo] FOREIGN KEY ([cd_caracteristica_laudo]) REFERENCES [dbo].[Caracteristica_Laudo] ([cd_caracteristica_laudo])
);

