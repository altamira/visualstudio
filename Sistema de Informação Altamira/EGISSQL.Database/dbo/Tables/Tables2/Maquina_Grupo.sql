CREATE TABLE [dbo].[Maquina_Grupo] (
    [sg_grupo_maquina] CHAR (10)    NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    [cd_grupo_maquina] INT          NOT NULL,
    [nm_grupo_maquina] VARCHAR (40) NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    CONSTRAINT [PK_Maquina_Grupo] PRIMARY KEY CLUSTERED ([cd_grupo_maquina] ASC) WITH (FILLFACTOR = 90)
);

