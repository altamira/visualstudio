CREATE TABLE [dbo].[Area_Auditoria] (
    [cd_area]                 INT          NOT NULL,
    [qt_frequencia_auditoria] INT          NULL,
    [cd_criticidade]          INT          NULL,
    [cd_complexidade]         INT          NULL,
    [nm_obs_area_auditoria]   VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Area_Auditoria] PRIMARY KEY CLUSTERED ([cd_area] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Area_Auditoria_Complexidade_Ambiental] FOREIGN KEY ([cd_complexidade]) REFERENCES [dbo].[Complexidade_Ambiental] ([cd_complexidade])
);

