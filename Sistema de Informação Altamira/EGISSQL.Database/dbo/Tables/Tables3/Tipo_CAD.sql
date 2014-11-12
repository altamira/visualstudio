CREATE TABLE [dbo].[Tipo_CAD] (
    [cd_tipo_cad] INT          NOT NULL,
    [nm_tipo_cad] VARCHAR (30) NULL,
    [sg_tipo_cad] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Tipo_CAD] PRIMARY KEY CLUSTERED ([cd_tipo_cad] ASC) WITH (FILLFACTOR = 90)
);

