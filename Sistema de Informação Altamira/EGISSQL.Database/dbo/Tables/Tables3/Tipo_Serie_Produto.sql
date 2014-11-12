CREATE TABLE [dbo].[Tipo_Serie_Produto] (
    [cd_tipo_serie_produto] INT          NOT NULL,
    [nm_tipo_serie_produto] VARCHAR (40) NULL,
    [sg_tipo_serie_produto] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ds_tipo_serie_produto] TEXT         NULL,
    [sg_tipo_produto]       CHAR (10)    NULL,
    CONSTRAINT [PK_Tipo_Serie_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_serie_produto] ASC) WITH (FILLFACTOR = 90)
);

