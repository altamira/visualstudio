CREATE TABLE [dbo].[Produto_Cemiterio] (
    [cd_produto]             INT        NOT NULL,
    [cd_empresa]             INT        NULL,
    [vl_vista_prod_cemit]    FLOAT (53) NULL,
    [vl_entrada_prod_cemit]  FLOAT (53) NULL,
    [cd_grupo_composicao]    INT        NOT NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [ic_ent_lateral_produto] CHAR (1)   NULL,
    CONSTRAINT [PK_Produto_Cemiterio] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Cemiterio_Grupo_Composicao] FOREIGN KEY ([cd_grupo_composicao]) REFERENCES [dbo].[Grupo_Composicao] ([cd_grupo_composicao])
);

