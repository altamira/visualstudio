CREATE TABLE [dbo].[Tabela_Preco_Condicao_Pagto] (
    [cd_tabela_preco]           INT          NOT NULL,
    [cd_condicao_pagamento]     INT          NOT NULL,
    [pc_acrescimo_tabela_preco] FLOAT (53)   NULL,
    [pc_desconto_tabela_preco]  FLOAT (53)   NULL,
    [nm_obs_tabela_preco]       VARCHAR (40) NULL,
    [nm_cabecalho_tabela_preco] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_ordem_tabela_preco]     INT          NOT NULL,
    CONSTRAINT [PK_Tabela_Preco_Condicao_Pagto] PRIMARY KEY CLUSTERED ([cd_tabela_preco] ASC, [cd_condicao_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Preco_Condicao_Pagto_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento])
);

