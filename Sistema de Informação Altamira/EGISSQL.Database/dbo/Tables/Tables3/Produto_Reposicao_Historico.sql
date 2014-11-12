CREATE TABLE [dbo].[Produto_Reposicao_Historico] (
    [cd_produto]                 INT          NOT NULL,
    [cd_reposicao_historico]     INT          NOT NULL,
    [dt_reposicao_historico]     DATETIME     NOT NULL,
    [vl_reposicao_historico]     FLOAT (53)   NULL,
    [cd_moeda]                   INT          NULL,
    [nm_obs_reposicao_historico] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Produto_Reposicao_Historico] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_reposicao_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Reposicao_Historico_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

