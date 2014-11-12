CREATE TABLE [dbo].[Tipo_Guia_Fio] (
    [cd_tipo_guia_fio] INT          NOT NULL,
    [nm_tipo_guia_fio] VARCHAR (40) NULL,
    [sg_tipo_guia_fio] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Guia_Fio] PRIMARY KEY CLUSTERED ([cd_tipo_guia_fio] ASC) WITH (FILLFACTOR = 90)
);

