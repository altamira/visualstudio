CREATE TABLE [dbo].[Produto_Literatura] (
    [cd_produto]                   INT           NOT NULL,
    [cd_produto_literatura]        INT           NOT NULL,
    [ds_produto_literatura]        TEXT          NULL,
    [nm_documento_prod_literatura] VARCHAR (100) NULL,
    [nm_obs_produto_literatura]    VARCHAR (60)  NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    CONSTRAINT [PK_Produto_Literatura] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_literatura] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Literatura_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

