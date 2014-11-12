CREATE TABLE [dbo].[Fase_Produto] (
    [cd_fase_produto]          INT          NOT NULL,
    [nm_fase_produto]          VARCHAR (30) NOT NULL,
    [sg_fase_produto]          CHAR (10)    NOT NULL,
    [cd_imagem]                INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_produto_saldo]         INT          NULL,
    [ic_fase_inativa]          CHAR (1)     NULL,
    [ic_fase_terceiro]         CHAR (1)     NULL,
    [ic_estoque_fase_produto]  CHAR (1)     NULL,
    [cd_metodo_valoracao]      INT          NULL,
    [cd_tipo_grupo_inventario] INT          NULL,
    [ic_conversao_multiplo]    CHAR (1)     NULL,
    [ic_fase_receita]          CHAR (1)     NULL,
    [ic_registro_inventario]   CHAR (1)     NULL,
    CONSTRAINT [PK_Fase_Produto] PRIMARY KEY CLUSTERED ([cd_fase_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fase_Produto_Metodo_Valoracao] FOREIGN KEY ([cd_metodo_valoracao]) REFERENCES [dbo].[Metodo_Valoracao] ([cd_metodo_valoracao]),
    CONSTRAINT [FK_Fase_Produto_Tipo_Grupo_Inventario] FOREIGN KEY ([cd_tipo_grupo_inventario]) REFERENCES [dbo].[Tipo_Grupo_Inventario] ([cd_tipo_grupo_inventario])
);

