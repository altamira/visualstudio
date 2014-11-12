CREATE TABLE [dbo].[Grupo_Maquina] (
    [cd_grupo_maquina]          INT          NOT NULL,
    [nm_grupo_maquina]          VARCHAR (40) NOT NULL,
    [sg_grupo_maquina]          CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_processo_grupo_maquina] CHAR (1)     NULL,
    [nm_fantasia_grupo_maquina] VARCHAR (15) NULL,
    CONSTRAINT [PK_Grupo_Maquina] PRIMARY KEY CLUSTERED ([cd_grupo_maquina] ASC) WITH (FILLFACTOR = 90)
);

