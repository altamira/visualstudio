CREATE TABLE [dbo].[Grupo_Gerencial_Idioma] (
    [cd_grupo_gerencial]        INT          NOT NULL,
    [cd_idioma]                 INT          NOT NULL,
    [nm_grupo_gerencial_idioma] VARCHAR (50) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Gerencial_Idioma] PRIMARY KEY CLUSTERED ([cd_grupo_gerencial] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Gerencial_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

