CREATE TABLE [dbo].[Inventario_Fisico] (
    [dt_inventario]          DATETIME     NOT NULL,
    [cd_fase_produto]        INT          NOT NULL,
    [cd_produto]             INT          NOT NULL,
    [nm_localizacao_produto] VARCHAR (20) NULL,
    [nm_modulo_localizacao]  VARCHAR (10) NULL,
    [qt_atual_sistema]       FLOAT (53)   NULL,
    [qt_contagem1]           FLOAT (53)   NULL,
    [qt_contagem2]           FLOAT (53)   NULL,
    [qt_contagem3]           FLOAT (53)   NULL,
    [qt_contagem4]           FLOAT (53)   NULL,
    [qt_contagem5]           FLOAT (53)   NULL,
    [qt_real]                FLOAT (53)   NULL,
    CONSTRAINT [PK_Inventario_Fisico] PRIMARY KEY CLUSTERED ([dt_inventario] ASC, [cd_fase_produto] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90)
);

