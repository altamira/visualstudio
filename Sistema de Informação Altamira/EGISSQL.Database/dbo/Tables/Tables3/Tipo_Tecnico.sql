CREATE TABLE [dbo].[Tipo_Tecnico] (
    [cd_tipo_tecnico] INT          NOT NULL,
    [nm_tipo_tecnico] VARCHAR (40) NULL,
    [sg_tipo_tecnico] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Tecnico] PRIMARY KEY CLUSTERED ([cd_tipo_tecnico] ASC) WITH (FILLFACTOR = 90)
);

