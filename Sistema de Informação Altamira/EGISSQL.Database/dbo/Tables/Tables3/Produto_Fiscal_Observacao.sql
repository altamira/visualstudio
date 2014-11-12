CREATE TABLE [dbo].[Produto_Fiscal_Observacao] (
    [cd_produto]             INT          NOT NULL,
    [cd_item_obs_produto]    INT          NOT NULL,
    [cd_obs_padrao_nf]       INT          NOT NULL,
    [nm_compl_obs_padrao_nf] VARCHAR (60) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_imprime_obs_produto] CHAR (1)     NULL,
    CONSTRAINT [PK_Produto_Fiscal_Observacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_item_obs_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Fiscal_Observacao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

