CREATE TABLE [dbo].[Sub_Produto_Especial] (
    [cd_sub_produto_especial]  INT          NOT NULL,
    [nm_sub_produto_especial]  VARCHAR (40) NULL,
    [sg_sub_produto_especial]  CHAR (10)    NULL,
    [nm_fantasia_sub_prod_esp] VARCHAR (30) NULL,
    [cd_ordem_sub_prod_esp]    INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [cd_grupo_produto]         INT          NULL,
    [cd_serie_produto]         INT          NULL,
    [cd_ordem_sub_produto_esp] INT          NULL,
    [cd_categoria_produto]     INT          NULL,
    CONSTRAINT [PK_Sub_Produto_Especial] PRIMARY KEY CLUSTERED ([cd_sub_produto_especial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sub_Produto_Especial_Categoria_Produto] FOREIGN KEY ([cd_categoria_produto]) REFERENCES [dbo].[Categoria_Produto] ([cd_categoria_produto])
);

