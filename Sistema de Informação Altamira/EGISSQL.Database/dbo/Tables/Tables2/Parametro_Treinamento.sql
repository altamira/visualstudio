﻿CREATE TABLE [dbo].[Parametro_Treinamento] (
    [cd_empresa] INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Parametro_Treinamento] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

