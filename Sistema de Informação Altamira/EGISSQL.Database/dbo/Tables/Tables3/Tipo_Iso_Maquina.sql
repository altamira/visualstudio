CREATE TABLE [dbo].[Tipo_Iso_Maquina] (
    [cd_tipo_iso_maquina] INT          NOT NULL,
    [nm_tipo_iso_maquina] VARCHAR (30) NOT NULL,
    [sg_tipo_iso_maquina] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Iso_Maquina] PRIMARY KEY CLUSTERED ([cd_tipo_iso_maquina] ASC) WITH (FILLFACTOR = 90)
);

