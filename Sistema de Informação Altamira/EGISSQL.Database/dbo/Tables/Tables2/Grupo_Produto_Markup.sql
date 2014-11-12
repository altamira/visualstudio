CREATE TABLE [dbo].[Grupo_Produto_Markup] (
    [cd_grupo_produto]     INT          NOT NULL,
    [cd_item_grupo_markup] INT          NOT NULL,
    [cd_aplicacao_markup]  INT          NULL,
    [nm_obs_grupo_markup]  VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_moeda]             INT          NULL,
    CONSTRAINT [PK_Grupo_Produto_Markup] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_item_grupo_markup] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Markup_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

