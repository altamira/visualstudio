CREATE TABLE [dbo].[Grupo_Local_Cemiterio] (
    [cd_grupo_local_cemiterio] INT          NOT NULL,
    [nm_grupo_local_cemiterio] VARCHAR (40) NULL,
    [sg_grupo_local_cemiterio] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Local_Cemiterio] PRIMARY KEY CLUSTERED ([cd_grupo_local_cemiterio] ASC) WITH (FILLFACTOR = 90)
);

