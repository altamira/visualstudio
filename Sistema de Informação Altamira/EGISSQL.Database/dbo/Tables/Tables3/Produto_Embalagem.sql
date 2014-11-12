CREATE TABLE [dbo].[Produto_Embalagem] (
    [cd_produto]                INT          NOT NULL,
    [cd_produto_embalagem]      INT          NOT NULL,
    [cd_tipo_embalagem]         INT          NULL,
    [nm_produto_embalagem]      VARCHAR (40) NULL,
    [ic_orig_produto_embalagem] CHAR (1)     NULL,
    [qt_produto_embalagem]      FLOAT (53)   NULL,
    [pc_produto_embalagem]      FLOAT (53)   NULL,
    [qt_frac_produto_embalagem] FLOAT (53)   NULL,
    [nm_obs_produto_embalagem]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_categoria_produto]      INT          NULL,
    [qt_minimo_embalagem]       FLOAT (53)   NULL,
    [qt_peso_bruto_embalagem]   FLOAT (53)   NULL,
    [qt_peso_liquido_embalagem] FLOAT (53)   NULL,
    [qt_cubagem_embalagem]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Produto_Embalagem] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_embalagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Embalagem_Tipo_Embalagem] FOREIGN KEY ([cd_tipo_embalagem]) REFERENCES [dbo].[Tipo_Embalagem] ([cd_tipo_embalagem])
);

