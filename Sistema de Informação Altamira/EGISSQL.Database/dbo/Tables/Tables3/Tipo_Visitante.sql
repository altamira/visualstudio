CREATE TABLE [dbo].[Tipo_Visitante] (
    [cd_tipo_visitante] INT          NOT NULL,
    [nm_tipo_visitante] VARCHAR (40) NULL,
    [sg_tipo_visitante] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Visitante] PRIMARY KEY CLUSTERED ([cd_tipo_visitante] ASC) WITH (FILLFACTOR = 90)
);

