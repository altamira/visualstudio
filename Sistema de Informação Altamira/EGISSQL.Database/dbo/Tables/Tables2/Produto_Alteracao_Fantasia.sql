CREATE TABLE [dbo].[Produto_Alteracao_Fantasia] (
    [cd_produto_alteracao]     INT          NOT NULL,
    [cd_produto]               INT          NOT NULL,
    [nm_fantasia_produto]      VARCHAR (30) NULL,
    [nm_novo_fantasia_produto] VARCHAR (30) NULL,
    [nm_obs_produto_alteracao] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [dt_alteracao_produto]     DATETIME     NULL,
    CONSTRAINT [PK_Produto_Alteracao_Fantasia] PRIMARY KEY CLUSTERED ([cd_produto_alteracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Alteracao_Fantasia_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

