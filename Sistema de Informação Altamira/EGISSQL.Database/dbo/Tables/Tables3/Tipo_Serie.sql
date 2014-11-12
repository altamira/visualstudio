CREATE TABLE [dbo].[Tipo_Serie] (
    [cd_tipo_serie] INT          NOT NULL,
    [nm_tipo_serie] VARCHAR (40) NULL,
    [sg_tipo_serie] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Serie] PRIMARY KEY CLUSTERED ([cd_tipo_serie] ASC) WITH (FILLFACTOR = 90)
);

