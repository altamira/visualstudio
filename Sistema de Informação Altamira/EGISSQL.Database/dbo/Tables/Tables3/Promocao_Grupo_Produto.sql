CREATE TABLE [dbo].[Promocao_Grupo_Produto] (
    [cd_promocao]          INT          NOT NULL,
    [cd_grupo_produto]     INT          NOT NULL,
    [pc_promocao_desconto] FLOAT (53)   NULL,
    [nm_obs_promocao]      VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Promocao_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_promocao] ASC, [cd_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Promocao_Grupo_Produto_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

