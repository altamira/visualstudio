CREATE TABLE [dbo].[Tipo_Caderno] (
    [cd_tipo_caderno]       INT          NOT NULL,
    [nm_tipo_caderno]       VARCHAR (40) NULL,
    [sg_tipo_caderno]       CHAR (10)    NULL,
    [qt_ordem_tipo_caderno] INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Caderno] PRIMARY KEY CLUSTERED ([cd_tipo_caderno] ASC) WITH (FILLFACTOR = 90)
);

