CREATE TABLE [dbo].[Grupo_FMEA] (
    [cd_grupo_fmea] INT          NOT NULL,
    [nm_grupo_fmea] VARCHAR (40) NULL,
    [sg_grupo_fmea] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Grupo_FMEA] PRIMARY KEY CLUSTERED ([cd_grupo_fmea] ASC) WITH (FILLFACTOR = 90)
);

