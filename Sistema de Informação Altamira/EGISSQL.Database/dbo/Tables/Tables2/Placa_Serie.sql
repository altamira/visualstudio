CREATE TABLE [dbo].[Placa_Serie] (
    [cd_serie_produto]         INT        NOT NULL,
    [cd_sub_serie]             INT        NOT NULL,
    [cd_placa]                 INT        NOT NULL,
    [cd_grupo_produto]         INT        NOT NULL,
    [cd_produto]               INT        NOT NULL,
    [qt_espessura_placa_serie] FLOAT (53) NULL,
    [qt_largura_placa_serie]   FLOAT (53) NULL,
    [qt_comprim_placa_serie]   FLOAT (53) NULL,
    [cd_tipo_serie]            INT        NULL,
    [qt_peso_placa_serie]      FLOAT (53) NULL,
    [cd_mat_prima]             INT        NULL,
    [ic_programa_cnc]          CHAR (1)   NULL,
    [ic_estrutura_placa_serie] CHAR (1)   NULL,
    [qt_placa_serie]           FLOAT (53) NULL,
    [qt_esp_placa]             FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Placa_Serie] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_sub_serie] ASC, [cd_placa] ASC, [cd_grupo_produto] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Placa_Serie_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima]),
    CONSTRAINT [FK_Placa_Serie_Tipo_Serie] FOREIGN KEY ([cd_tipo_serie]) REFERENCES [dbo].[Tipo_Serie] ([cd_tipo_serie])
);

