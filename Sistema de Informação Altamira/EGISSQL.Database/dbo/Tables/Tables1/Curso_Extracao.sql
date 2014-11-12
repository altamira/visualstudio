CREATE TABLE [dbo].[Curso_Extracao] (
    [cd_serie_produto]          INT          NOT NULL,
    [cd_tipo_serie_produto]     INT          NOT NULL,
    [cd_tipo_curso_extracao]    INT          NOT NULL,
    [cd_item_curso_extracao]    INT          NOT NULL,
    [qt_medida_curso_extracao]  FLOAT (53)   NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [qt_item_curso_extracao]    FLOAT (53)   NOT NULL,
    [nm_tipo_obs_curso_extraca] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_tipo_montagem]          INT          NULL,
    [cd_produto_equivalente_y]  INT          NULL,
    [ic_montagem_g_curso_extra] CHAR (1)     NULL,
    [cd_montagem]               INT          NULL,
    [cd_ordem_curso_extracao]   INT          NULL,
    CONSTRAINT [PK_Curso_Extracao] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie_produto] ASC, [cd_tipo_curso_extracao] ASC, [cd_item_curso_extracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Curso_Extracao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

