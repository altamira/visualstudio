CREATE TABLE [dbo].[Grupo_DIPI] (
    [cd_grupo_dipi] INT          NOT NULL,
    [nm_grupo_dipi] VARCHAR (60) NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Grupo_DIPI] PRIMARY KEY CLUSTERED ([cd_grupo_dipi] ASC) WITH (FILLFACTOR = 90)
);

