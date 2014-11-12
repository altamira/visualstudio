CREATE TABLE [dbo].[Fornecedor_Concorrente_Produto] (
    [cd_fornecedor]             INT          NOT NULL,
    [cd_concorrente]            INT          NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [cd_produto_concorrente]    INT          NOT NULL,
    [nm_obs_forn_concorre_prod] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Fornecedor_Concorrente_Produto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_concorrente] ASC, [cd_produto] ASC, [cd_produto_concorrente] ASC) WITH (FILLFACTOR = 90)
);

