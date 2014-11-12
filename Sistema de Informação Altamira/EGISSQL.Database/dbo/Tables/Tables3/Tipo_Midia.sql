CREATE TABLE [dbo].[Tipo_Midia] (
    [cd_tipo_midia] INT          NOT NULL,
    [nm_tipo_midia] VARCHAR (40) NULL,
    [sg_tipo_midia] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Midia] PRIMARY KEY CLUSTERED ([cd_tipo_midia] ASC) WITH (FILLFACTOR = 90)
);

