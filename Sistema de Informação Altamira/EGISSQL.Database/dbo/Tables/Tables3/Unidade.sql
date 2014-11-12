CREATE TABLE [dbo].[Unidade] (
    [cd_unidade]       INT          NOT NULL,
    [nm_unidade]       VARCHAR (40) NULL,
    [sg_unidade]       CHAR (10)    NULL,
    [qt_fator_unidade] FLOAT (53)   NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([cd_unidade] ASC) WITH (FILLFACTOR = 90)
);

