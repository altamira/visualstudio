CREATE TABLE [dbo].[Coordenada] (
    [cd_serie_produto]      INT        NULL,
    [cd_tipo_serie_produto] INT        NULL,
    [cd_item_coordenada]    INT        NOT NULL,
    [cd_ordem_coordenada]   INT        NULL,
    [cd_tipo_coordenada]    INT        NULL,
    [qt_medida_x]           FLOAT (53) NULL,
    [qt_medida_y]           FLOAT (53) NULL,
    [cd_parametro_x]        INT        NULL,
    [cd_parametro_y]        INT        NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Coordenada] PRIMARY KEY CLUSTERED ([cd_item_coordenada] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Coordenada_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto]),
    CONSTRAINT [FK_Coordenada_Tipo_Coordenada] FOREIGN KEY ([cd_tipo_coordenada]) REFERENCES [dbo].[Tipo_Coordenada] ([cd_tipo_coordenada]),
    CONSTRAINT [FK_Coordenada_Tipo_Serie_Produto] FOREIGN KEY ([cd_tipo_serie_produto]) REFERENCES [dbo].[Tipo_Serie_Produto] ([cd_tipo_serie_produto])
);

