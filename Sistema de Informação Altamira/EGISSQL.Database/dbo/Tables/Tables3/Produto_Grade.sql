CREATE TABLE [dbo].[Produto_Grade] (
    [cd_produto]              INT          NOT NULL,
    [cd_produto_grade]        INT          NOT NULL,
    [cd_item_produto_grade]   INT          NOT NULL,
    [cd_tipo_grade]           INT          NULL,
    [nm_titulo_produto_grade] VARCHAR (40) NULL,
    [qt_inicio_produto_grade] FLOAT (53)   NULL,
    [qt_final_produto_grade]  FLOAT (53)   NULL,
    [nm_obs_produto_grade]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Produto_Grade] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_grade] ASC, [cd_item_produto_grade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Grade_Tipo_Grade] FOREIGN KEY ([cd_tipo_grade]) REFERENCES [dbo].[Tipo_Grade] ([cd_tipo_grade])
);

