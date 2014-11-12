CREATE TABLE [dbo].[Laudo_Caracteristica] (
    [cd_laudo]                INT           NOT NULL,
    [cd_laudo_caracteristica] INT           NOT NULL,
    [cd_caracteristica_laudo] INT           NULL,
    [nm_resultado_obtido]     VARCHAR (100) NULL,
    [nm_obs_caracteristica]   VARCHAR (60)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [nm_especificacao]        VARCHAR (100) NULL,
    [nm_metodo]               VARCHAR (100) NULL,
    [nm_resultado_empresa]    VARCHAR (100) NULL,
    [cd_tolerancia_produto]   INT           NULL,
    [nm_tolerancia_produto]   VARCHAR (15)  NULL,
    [cd_unidade_medida]       INT           NULL,
    [cd_tipo_medicao]         INT           NULL,
    [nm_plano_medicao]        VARCHAR (20)  NULL,
    [cd_ferramenta]           INT           NULL,
    [nm_ferramenta_laudo]     VARCHAR (40)  NULL,
    CONSTRAINT [PK_Laudo_Caracteristica] PRIMARY KEY CLUSTERED ([cd_laudo] ASC, [cd_laudo_caracteristica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Caracteristica_Caracteristica_Laudo] FOREIGN KEY ([cd_caracteristica_laudo]) REFERENCES [dbo].[Caracteristica_Laudo] ([cd_caracteristica_laudo])
);

