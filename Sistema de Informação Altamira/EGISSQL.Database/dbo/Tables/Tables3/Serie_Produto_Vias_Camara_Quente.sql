CREATE TABLE [dbo].[Serie_Produto_Vias_Camara_Quente] (
    [cd_serie_produto]         INT        NOT NULL,
    [qt_vias]                  INT        NOT NULL,
    [qt_tempo_passagem_fio]    FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_tempo_furacao_lateral] FLOAT (53) NULL,
    CONSTRAINT [PK_Serie_Produto_Vias_Camara_Quente] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [qt_vias] ASC) WITH (FILLFACTOR = 90)
);

