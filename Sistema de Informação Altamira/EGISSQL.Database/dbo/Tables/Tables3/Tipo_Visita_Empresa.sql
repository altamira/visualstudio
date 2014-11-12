CREATE TABLE [dbo].[Tipo_Visita_Empresa] (
    [cd_tipo_visita_empresa] INT          NOT NULL,
    [nm_tipo_visita_empresa] VARCHAR (40) NULL,
    [sg_tipo_visita_empresa] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Visita_Empresa] PRIMARY KEY CLUSTERED ([cd_tipo_visita_empresa] ASC) WITH (FILLFACTOR = 90)
);

