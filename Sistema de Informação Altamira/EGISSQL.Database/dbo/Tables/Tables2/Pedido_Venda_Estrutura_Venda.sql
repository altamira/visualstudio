CREATE TABLE [dbo].[Pedido_Venda_Estrutura_Venda] (
    [cd_pedido_venda]           INT          NOT NULL,
    [cd_estrutura_venda]        INT          NOT NULL,
    [ic_pagamento_comissao]     CHAR (1)     NULL,
    [pc_comissao_estrutura]     FLOAT (53)   NULL,
    [nm_obs_comissao_estrutura] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Venda_Estrutura_Venda] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_estrutura_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Estrutura_Venda_Estrutura_Venda] FOREIGN KEY ([cd_estrutura_venda]) REFERENCES [dbo].[Estrutura_Venda] ([cd_estrutura_venda])
);

