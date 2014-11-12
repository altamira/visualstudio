CREATE TABLE [dbo].[Produto_Mercado] (
    [cd_controle]             INT          NOT NULL,
    [cd_produto]              INT          NOT NULL,
    [dt_base_produto_mercado] DATETIME     NULL,
    [vl_produto_mercado]      FLOAT (53)   NULL,
    [cd_fonte_mercado]        INT          NULL,
    [nm_obs_produto]          VARCHAR (40) NULL,
    CONSTRAINT [PK_Produto_Mercado] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Mercado_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

