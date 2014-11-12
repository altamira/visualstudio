CREATE TABLE [dbo].[Categoria_Orcamento_Grupo] (
    [cd_categoria_Orcamento]  INT          NOT NULL,
    [cd_item_categoria_grupo] INT          NOT NULL,
    [cd_grupo_produto]        INT          NOT NULL,
    [nm_obs_categoria_grupo]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_ordem_calculo]        INT          NULL,
    [nm_obs_categoria_orcam]  VARCHAR (40) NULL,
    CONSTRAINT [PK_Categoria_Orcamento_Grupo] PRIMARY KEY CLUSTERED ([cd_categoria_Orcamento] ASC, [cd_item_categoria_grupo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Orcamento_Grupo_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

