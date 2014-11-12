CREATE TABLE [dbo].[Desenho_Componente] (
    [cd_serie_produto]          INT          NULL,
    [cd_tipo_serie_produto]     INT          NULL,
    [cd_montagem]               INT          NULL,
    [cd_placa]                  INT          NULL,
    [cd_ordem_desenho_comp]     INT          NOT NULL,
    [cd_coordenada]             INT          NULL,
    [qt_desenho_componente]     FLOAT (53)   NULL,
    [nm_desenho_componente]     VARCHAR (15) NULL,
    [qt_diametro_1]             FLOAT (53)   NULL,
    [qt_diametro_2]             FLOAT (53)   NULL,
    [qt_quadrante_desenho_comp] FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Desenho_Componente] PRIMARY KEY CLUSTERED ([cd_ordem_desenho_comp] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Desenho_Componente_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa]),
    CONSTRAINT [FK_Desenho_Componente_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto]),
    CONSTRAINT [FK_Desenho_Componente_Tipo_Serie_Produto] FOREIGN KEY ([cd_tipo_serie_produto]) REFERENCES [dbo].[Tipo_Serie_Produto] ([cd_tipo_serie_produto])
);

