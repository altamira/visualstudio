CREATE TABLE [dbo].[Amostra_Produto_Caracteristica] (
    [cd_amostra]                INT           NOT NULL,
    [cd_amostra_produto]        INT           NOT NULL,
    [cd_amostra_caracteristica] INT           NOT NULL,
    [nm_caracteristica]         VARCHAR (100) NULL,
    [ic_apresenta_laudo]        CHAR (1)      NULL,
    [nm_resultado_obtido]       VARCHAR (100) NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_caracteristica_amostra] INT           NULL,
    [cd_grupo_caracteristica]   INT           NULL,
    CONSTRAINT [PK_Amostra_Produto_Caracteristica] PRIMARY KEY CLUSTERED ([cd_amostra] ASC, [cd_amostra_produto] ASC, [cd_amostra_caracteristica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Amostra_Produto_Caracteristica_Grupo_Caracteristica_Amostra] FOREIGN KEY ([cd_grupo_caracteristica]) REFERENCES [dbo].[Grupo_Caracteristica_Amostra] ([cd_grupo_caracteristica])
);

