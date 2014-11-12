CREATE TABLE [dbo].[Tipo_Coordenada] (
    [cd_tipo_coordenada] INT          NOT NULL,
    [nm_tipo_coordenada] VARCHAR (30) NULL,
    [sg_tipo_coordenada] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Coordenada] PRIMARY KEY CLUSTERED ([cd_tipo_coordenada] ASC) WITH (FILLFACTOR = 90)
);

