CREATE TABLE [dbo].[Grupo_Esquadro] (
    [cd_grupo_esquadro] INT          NOT NULL,
    [nm_grupo_esquadro] VARCHAR (40) NOT NULL,
    [sg_grupo_esquadro] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    CONSTRAINT [PK_Grupo_Esquadro] PRIMARY KEY CLUSTERED ([cd_grupo_esquadro] ASC) WITH (FILLFACTOR = 90)
);

