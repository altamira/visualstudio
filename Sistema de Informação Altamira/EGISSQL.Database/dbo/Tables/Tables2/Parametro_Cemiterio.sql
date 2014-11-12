CREATE TABLE [dbo].[Parametro_Cemiterio] (
    [cd_empresa]               INT        NOT NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_registro_obito_pagina] INT        NULL,
    [qt_ano_exumacao]          INT        NULL,
    [vl_exumacao]              FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Cemiterio] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

