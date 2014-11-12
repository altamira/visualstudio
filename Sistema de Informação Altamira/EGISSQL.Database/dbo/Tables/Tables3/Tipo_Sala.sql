CREATE TABLE [dbo].[Tipo_Sala] (
    [cd_tipo_sala] INT          NOT NULL,
    [nm_tipo_sala] VARCHAR (40) NULL,
    [sg_tipo_sala] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Sala] PRIMARY KEY CLUSTERED ([cd_tipo_sala] ASC) WITH (FILLFACTOR = 90)
);

