CREATE TABLE [dbo].[Fornecedor_Produto_Condicao_Pagto] (
    [cd_fornecedor]            INT          NOT NULL,
    [cd_produto]               INT          NOT NULL,
    [cd_condicao_pagamento]    INT          NOT NULL,
    [cd_moeda]                 INT          NULL,
    [cd_item_produto_condicao] INT          NOT NULL,
    [vl_produto_condicao]      FLOAT (53)   NULL,
    [dt_produto_condicao]      DATETIME     NULL,
    [nm_obs_produto_condicao]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [vl_frete_produto]         FLOAT (53)   NULL,
    [vl_subs_trib_produto]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Fornecedor_Produto_Condicao_Pagto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_produto] ASC, [cd_condicao_pagamento] ASC, [cd_item_produto_condicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Produto_Condicao_Pagto_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

