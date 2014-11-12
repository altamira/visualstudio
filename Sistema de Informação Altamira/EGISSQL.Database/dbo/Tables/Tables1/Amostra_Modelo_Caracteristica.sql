CREATE TABLE [dbo].[Amostra_Modelo_Caracteristica] (
    [cd_amostra_modelo]         INT      NOT NULL,
    [cd_amostra_caracteristica] INT      NOT NULL,
    [cd_caracteristica_amostra] INT      NULL,
    [ic_apresenta_laudo]        CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [cd_grupo_caracteristica]   INT      NULL,
    CONSTRAINT [PK_Amostra_Modelo_Caracteristica] PRIMARY KEY CLUSTERED ([cd_amostra_modelo] ASC, [cd_amostra_caracteristica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Amostra_Modelo_Caracteristica_Caracteristica_Amostra] FOREIGN KEY ([cd_caracteristica_amostra]) REFERENCES [dbo].[Caracteristica_Amostra] ([cd_caracteristica_amostra]),
    CONSTRAINT [FK_Amostra_Modelo_Caracteristica_Grupo_Caracteristica_Amostra] FOREIGN KEY ([cd_grupo_caracteristica]) REFERENCES [dbo].[Grupo_Caracteristica_Amostra] ([cd_grupo_caracteristica])
);

