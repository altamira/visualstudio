CREATE TABLE [dbo].[Tabela_Preco_Importacao] (
    [cd_tabela_preco]        INT          NOT NULL,
    [dt_inicial_preco]       DATETIME     NOT NULL,
    [dt_final_preco]         DATETIME     NOT NULL,
    [cd_produto]             INT          NOT NULL,
    [vl_produto_importacao]  FLOAT (53)   NULL,
    [cd_moeda]               INT          NULL,
    [nm_obs_tabela_preco]    VARCHAR (60) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [pc_desconto_importacao] FLOAT (53)   NULL,
    [vl_moeda_periodo]       FLOAT (53)   NULL,
    CONSTRAINT [PK_Tabela_Preco_Importacao] PRIMARY KEY CLUSTERED ([cd_tabela_preco] ASC, [dt_inicial_preco] ASC, [dt_final_preco] ASC, [cd_produto] ASC),
    CONSTRAINT [FK_Tabela_Preco_Importacao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

