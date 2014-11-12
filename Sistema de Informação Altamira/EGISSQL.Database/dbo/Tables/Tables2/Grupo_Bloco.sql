CREATE TABLE [dbo].[Grupo_Bloco] (
    [cd_grupo_bloco] INT          NOT NULL,
    [nm_grupo_bloco] VARCHAR (60) NULL,
    [sg_grupo_bloco] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Bloco] PRIMARY KEY CLUSTERED ([cd_grupo_bloco] ASC) WITH (FILLFACTOR = 90)
);

