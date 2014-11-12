CREATE TABLE [dbo].[Tipo_Aspecto_Ambiental] (
    [cd_tipo_aspecto] INT          NOT NULL,
    [nm_tipo_aspecto] VARCHAR (40) NULL,
    [sg_tipo_aspecto] CHAR (10)    NULL,
    [ds_tipo_aspecto] TEXT         NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Aspecto_Ambiental] PRIMARY KEY CLUSTERED ([cd_tipo_aspecto] ASC) WITH (FILLFACTOR = 90)
);

